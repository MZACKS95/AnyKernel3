name: Pack AnyKernel3 Zip

on:
  workflow_dispatch:

jobs:
  pack:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout My Repo (Ambil Image.gz)
        uses: actions/checkout@v4

      - name: Clone Latest Official AnyKernel3
        run: |
          git clone --depth=1 https://github.com ak3_latest
          cp Image.gz ak3_latest/

      - name: Configure anykernel.sh for X6833B
        run: |
          cat << 'EOF' > ak3_latest/anykernel.sh
          ### AnyKernel3 Ramdisk Mod Script
          ## osm0sis @ xda-developers

          properties() { '
          kernel.string=Kernel-Rama-5.10.272-X6833B
          do.devicecheck=0
          do.modules=0
          do.systemless=1
          do.cleanup=1
          do.cleanuponabort=0
          '; }

          block=auto;
          is_slot_device=auto;
          ramdisk_compression=auto;
          patch_vbmeta_flag=auto;

          . tools/ak3-core.sh;

          split_boot;
          flash_boot;
          EOF

      - name: Create Flashable Zip
        run: |
          cd ak3_latest
          zip -r9 ../Kernel-Rama-5.10.272-X6833B-Fixed.zip * -x .git README.md *placeholder

      - name: Upload Zip Artifact
        uses: actions/upload-artifact@v4
        with:
          name: Kernel-Rama-5.10.272-X6833B-Fixed
          path: Kernel-Rama-5.10.272-X6833B-Fixed.zip
