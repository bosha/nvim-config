# NeoVim configuration

Personal neovim configuration. It’s not a project or something but rather a convenient way for me to version and install it on various machines I own and manage.

## Installation

```bash
bash <(wget -q -O - https://raw.githubusercontent.com/bosha/nvim-config/master/install.sh)
```

After that open the neovim and give [lazy.nvim](https://github.com/folke/lazy.nvim) some time to download itself and install plugins.

### Nerdfont

Install the [Nerdfont](https://www.nerdfonts.com) to make beautiful [devicons](https://github.com/nvim-tree/nvim-web-devicons) work properly. I'm on MacOS and really like the default terminal font on Mac which is Monaco. You can download the patched Nerdfont version of Monaco from this repo - [monaco-nerd-font](https://github.com/thep0y/monaco-nerd-font).

Some fonts has patched versions in the brew repository and you can install them using it:

```bash
➜~ brew search nerdfont
==> Formulae
nerdfetch

==> Casks
font-0xproto-nerd-font                      font-departure-mono-nerd-font               font-iosevka-nerd-font                      font-profont-nerd-font
font-3270-nerd-font                         font-droid-sans-mono-nerd-font              font-iosevka-term-nerd-font                 font-proggy-clean-tt-nerd-font
font-agave-nerd-font                        font-envy-code-r-nerd-font                  font-iosevka-term-slab-nerd-font            font-recursive-mono-nerd-font
font-anonymice-nerd-font                    font-fantasque-sans-mono-nerd-font          font-jetbrains-mono-nerd-font ✔             font-roboto-mono-nerd-font
font-arimo-nerd-font                        font-fira-code-nerd-font                    font-lekton-nerd-font                       font-sauce-code-pro-nerd-font
font-aurulent-sans-mono-nerd-font           font-fira-mono-nerd-font                    font-liberation-nerd-font                   font-shure-tech-mono-nerd-font
font-bigblue-terminal-nerd-font             font-geist-mono-nerd-font                   font-lilex-nerd-font                        font-space-mono-nerd-font
font-bitstream-vera-sans-mono-nerd-font     font-go-mono-nerd-font                      font-m+-nerd-font                           font-symbols-only-nerd-font
font-blex-mono-nerd-font                    font-gohufont-nerd-font                     font-martian-mono-nerd-font                 font-terminess-ttf-nerd-font
font-caskaydia-cove-nerd-font               font-hack-nerd-font                         font-meslo-lg-nerd-font                     font-tinos-nerd-font
font-caskaydia-mono-nerd-font               font-hasklug-nerd-font                      font-monaspace-nerd-font                    font-ubuntu-mono-nerd-font ✔
font-code-new-roman-nerd-font               font-heavy-data-nerd-font                   font-monocraft-nerd-font                    font-ubuntu-nerd-font
font-comic-shanns-mono-nerd-font            font-hurmit-nerd-font                       font-monofur-nerd-font                      font-ubuntu-sans-nerd-font
font-commit-mono-nerd-font                  font-im-writing-nerd-font                   font-monoid-nerd-font                       font-victor-mono-nerd-font
font-cousine-nerd-font                      font-inconsolata-go-nerd-font               font-mononoki-nerd-font                     font-zed-mono-nerd-font
font-d2coding-nerd-font                     font-inconsolata-lgc-nerd-font              font-noto-nerd-font                         netron
font-daddy-time-mono-nerd-font              font-inconsolata-nerd-font                  font-open-dyslexic-nerd-font
font-dejavu-sans-mono-nerd-font             font-intone-mono-nerd-font                  font-overpass-nerd-font
```

### Additional tools to install

In order to make some things work properly you need to install couple additional tools:

- **rg** - for telescope.
- **prettier** and **prettierd** for the markdown files formatting.
- **stylua** for the lua formatting

All can be installed with brew:

```bash
brew install rg prettier prettierd stylua
```
