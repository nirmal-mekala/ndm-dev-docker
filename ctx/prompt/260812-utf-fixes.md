### prompt

i have been getting some issues in tmux where i expect an arrow glyph but i am
getting a _ glyph instead

part of it has to do with exporting LANG and LC_ALL as en_US.UTF-8, but after
doing that i get this eror


```
/bin/bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8): No such file or directory
/bin/bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8): No such file or directory
~ → Wed Aug 12 08:55 PM
```

can you improve the apt installs in the Dockerfile to handle this i believe we need

```bash
sudo apt-get update
sudo apt-get install -y locales
sudo locale-gen en_US.UTF-8
```

i think it might look like

```
# Install locales package and generate en_US.UTF-8
RUN apt-get update && apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

# Set the environment variables
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
```


