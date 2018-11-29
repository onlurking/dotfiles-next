# Dotfiles

remote installation:
```
curl -fsSL onlurking-dotfiles.surge.sh/install.sh | bash -s -- -h
```

local installation:
```
git clone https://github.com/onlurking/dotfiles-next dotfiles && \
cd $_ && chmod +x ./install.sh && ./install.sh -h && \
echo 'run: ./install.sh with flags'

```

format code using [shfmt](https://github.com/mvdan/sh):
```
shfmt -i 2 -ci -s -bn -sr -w *.sh
```
