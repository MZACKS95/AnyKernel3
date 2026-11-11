name: Pack AnyKernel3 Zip

on:
  workflow_dispatch:

jobs:
  pack:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout My Repo
        uses: actions/checkout@v4

      - name: Verify Image.gz Format
        run: |
          file Image.gz
          # Memastikan Image.gz adalah GZIP murni, bukan tar.gz
          if file Image.gz | grep -q "tar"; then
            echo "ERROR: File Image.gz Anda berformat tar.gz! Kompres ulang dengan format gzip murni."
            exit 1
          fi

      - name: Clone & Configure Official AnyKernel3
        run: |
          git clone --depth=1 https://github.com ak3_latest
          cp Image.gz ak3_latest/
          
          # Konfigurasi aman untuk Infinix X6833B (GKI 5.10)
          sed -i 's/do.devicecheck=1/do.devicecheck=0/g' ak3_latest/anykernel.sh
          sed -i 's!block=/dev/block/platform/omap/omap_hsmmc.0/by-name/boot;!block=auto;!g' ak3_latest/anykernel.sh
          sed -i 's/is_slot_device=0;/is_slot_device=auto;/g' ak3_latest/anykernel.sh
          sed -i 's/dump_boot;/split_boot;/g' ak3_latest/anykernel.sh
          sed -i 's/write_boot;/flash_boot;/g' ak3_latest/anykernel.sh

      - name: Create Flashable Zip
        run: |
          cd ak3_latest
          zip -r9 ../Kernel-Rama-5.10.272-X6833B-v2.zip * -x .git README.md *placeholder

      - name: Upload Zip Artifact
        uses: actions/upload-artifact@v4
        with:
          name: Kernel-Rama-5.10.272-X6833B-v2
          path: Kernel-Rama-5.10.272-X6833B-v2.zip
