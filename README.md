# "Skulle bare sette opp en minecraft server"
Ikke sant...

## NixOS
VPS-en kjører [NixOS](https://media.licdn.com/dms/image/v2/D4D10AQFEYVT2pDfuMQ/image-shrink_1280/image-shrink_1280/0/1719734521233?e=2147483647&v=beta&t=dXxpQABC7EHzBi1CwlyKVtNhLPpxiRo-KPz-fOm_zUo) med konfigurasjonene i configuration.nix. Hele strukturen til VPS-en er beskrevet i configuration.nix-fila. Det eneste unntaket er tilkoblingsdetaljene til Google-Driven der backupene lagres siden dette er hemmelig.
Det betyr at alt maskinen gjør og inneholder står beskrevet i dette repoet (med unntak av dataen til serveren).

## services.minecraft-server
NixPkgs inneholder en minecraft server modul, og en pakke for siste versjon av paper sin server som fungerer med den. Det betyr at man kan kjøre serveren som en integrert modul i NixOS(i praksis kjøres dette eom en systemd-tjeneste).
```nix
services.minecraft-server = {
  enable = true;
  package = pkgs.papermcServers.papermc-1_21_10;
  ... [omitted]
};
```
Verre er det altså ikke å få satt opp serveren.

## Backups
Man skal jo ha det.
Rclone har en remote(eneste imperative oppsettet på VPSen). Det kjører en tjeneste som kopierer en tar-fil av minecraft-serveren 2 ganger i uka til en google drive.
Scriptet er laget med writeShellScriptBin(en av mange wrappers over derivation-funksjonen), slik at den kan få gjort noe som helst uten at nix får et anfall.

## Oppgradering
Etter den mildt traumatiserende opplevelsen det var å sette opp dette hadde det vært for dumt å måtte gå å pirke i VPSen selv.
05:00 hver natt trekker den oppdateringer fra dette repoet (som i seg selv er definert i dette repoet med magien av nix).
```nix
system.autoUpgrade = {
  enable = true;
  flake = "github:MrProgrammerMan/mc-server";
  dates = "05:00";
  upgrade = false;
};
```

Resten av oppsettet er egentlig unødvendig leftovers fra andre ting VPS-en brukes til.
