#!/usr/bin/env nu

def main [ job: string ] {
  let cfg = (if ($job == "push_remote_raisin") {
    {
      job:  "push_to_raisin"
      # TODO: rename the zrepl job
      # job: "push_remote_raisin"
      # use ssd+hdr on remote to unlock, bp to import
      remote: $"(tailscale ip --4 raisin)"
      ssd: "/dev/disk/by-id/usb-Realtek_RTL9210B-CG_012345678904-0:0"
      hdr: "/home/cole/.local/share/SyncThingData/Sync/ORION_NVME_SSD/header_raisin.img"
      bp: "orionraisinpool"
      secret: "orionraisin_luks"
    }
  } else if ($job == "push_local") {
    {
      job:  "push_to_orion"
      # TODO: rename the zrepl job
      # job: "push_local"
      remote: "localhost"
      ssd: "/dev/disk/by-id/usb-Realtek_RTL9210_NVME_012345678903-0:0"
      hdr: "/home/cole/.local/share/SyncThingData/Sync/ORION_NVME_SSD/header.img"
      bp: "orionpool"
      secret: "orion_luks"
    }
  } else {
    print -e "invalid job"
    exit -1
  })

  print -e $cfg
  # exit -1 # debug
  
  let luksdev = "orion"
  
  let pass = (prs show $cfg.secret | complete | get stdout | str trim)
  
  print -e "::: close backup pool"
  do -i { ssh $"($cfg.remote)" -- sudo sync; }
  do -i { ssh $"($cfg.remote)" -- sudo zpool export $cfg.bp }
  do -i { ssh $"($cfg.remote)" -- sudo cryptsetup luksClose $luksdev }
  
  print -e "::: open backup pool"
  
  # printf "%s" $pass out> /tmp/secret
  printf "%s" $pass | ssh $"($cfg.remote)" -- sudo cryptsetup luksOpen --header $cfg.hdr $cfg.ssd $luksdev -
  ssh $cfg.remote -- sudo zpool import $cfg.bp
  
  print -e $"::: trigger ($cfg.job)"
  # TRIGGER ZREPL to copy
  sudo zrepl signal wakeup $cfg.job
  
  # TODO: how to wait for replication to finish?
  print -e ""
  print -e "::: running, run these commands when it's done"
  print -e $"ssh ($cfg.remote) 'sudo sync; sudo zpool export ($cfg.bp); sudo sync; sudo cryptsetup luksClose ($luksdev); sudo sync; echo done'"
  
  sudo zrepl status
}
