{pkgs}: with pkgs; [
  nodejs_24
  imagemagick
  pnpm
   # (llama-cpp.override { useVulkan = true; })
  lunacy
#  prisma-engines
]
