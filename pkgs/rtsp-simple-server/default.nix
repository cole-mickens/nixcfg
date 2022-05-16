{ lib, fetchFromGitHub, buildGoModule }:

let
  metadata = {
    repo_git = "https://github.com/aler9/rtsp-simple-server";
    branch = "main";
    rev = "959b78586ae61a60c969e611ddaef1176d14ec7e";
    sha256 = "sha256-EqzehANnWzRjByzmQj5Aoy26Psa5XxvbI5s7XDH3xGc=";
    vendorSha256 = "sha256-WjWlgZwew+8bbzePOhalHeRyCVSd4FEGUFwFvLwqjzQ=";
  };
in buildGoModule rec {
  pname = "rtsp-simple-server";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "aler9";
    repo = "rtsp-simple-server";
    rev = metadata.rev;
    sha256 = metadata.sha256;
  };

  vendorSha256 = metadata.vendorSha256;

  doCheck = false; # TODO: they expect ffmpeg/docker when running tests, not ok

  meta = with lib; {
    verinfo = metadata;
    description = "ready-to-use RTSP / RTMP / HLS server and proxy that allows to read, publish and proxy video and audio streams";
    homepage = "https://github.com/aler9/rtsp-simple-server";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
