# General information on system configuration

## Shell

I am using **zsh** and to manage everything **ohmyzsh**. Get it from source, or just pull it

```
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
# check install.sh for funny stuff
./install.sh
```

## Terminal emulator

I am using **kitty**. I like that I can just display images on the command line with `icat image.png`. To display transparent .png files correctly, make sure your kitty shell is up to date. The one in Ubuntu 20.04 LTS is not.

```
curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh
./installer.sh
```

The current `kitty --version` I have is 0.21.1.

To be able to create my own animation at startup, I am compiling i3lock from source:

```
git clone https://github.com/Atrus7/i3lock
```

## Tiling window manager

I am using **i3**.

### Keyboard shortcuts

Some simple improvements.

#### Alt+F4 to close applications

Every application on Linux is using something different to close the application.
In `~/.config/i3/config` I make sure `Alt+F4` works in all cases:

```
set $alt_key Mod1

# Kill stuff by Alt+F4
bindsym $alt_key+F4 kill
```

#### Configure ~ key

On the Keychron the tilde is on the Escape key:

```
exec_always --no-startup-id xmodmap -e "keycode 9 = Escape asciitilde Escape"
```

I also add this to `~/.xmodmap`, but to do this by hotplugging is hard.

Using `inotifywait` and scripting/hacking around it is not cool. The easiest way to do this, but it's still not so easy is to create a udev rule, say:

```
SUBSYSTEM=="input", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="024f", SYMLINK+="keyboard" \
```

And then a systemd script:

```
mkdir -p ~/.config/systemd/user
vim keychron.service
```

with the following contents:

```
[Unit]
Description=Keyboard device
After=dev-keyboard.device
BindsTo=dev-keyboard.device
Requisite=dev-keyboard.device

[Service]
Environment=DISPLAY=:0
ExecStart=/home/anne/.config/i3/scripts/set_keyboard_settings_async.sh
StandardOutput=journal
RemainAfterExit=yes
Type=forking

[Install]
WantedBy=dev-keyboard.device
```

You see that a wrapper script is used (it has a delay of a few seconds).

Enable through:

```
systemctl --user enable keychron
udevadm control --reload-rules
```

Just `sudo udevadm trigger` won't work to trigger it, but physically hotplugging does.

#### Disable caps lock (so it can be used in discord)

Then it is nice to "disable" the `CAPS LOCK` key so it can be used in discord.

```
exec_always --no-startup-id setxkbmap -option ctrl:nocaps
```

Check with `xmodmap -pm` and you will see indeed nothing in the row starting with `lock`. On the other hand the key still works in discord, sweet!

### Power button

I prefer to switch my laptop off through something like

```
systemctl poweroff
```

Go to `/etc/systemd/logind.conf` and change `#HandlePowerKey=poweroff` into:

```
HandlePowerKey=ignore
```

Now, we might still want to use that button, but via an indirection. Create a `power_button.sh` script that uses `dmenu` and can depending on the users choice log out, lock, shut down, etc.

```
bindsym XF86PowerOff exec "$HOME/.config/i3/scripts/power_button.sh"
```

Nice! :-)

### Virtual scrolling

This is a matter of personal preference. If I play a lot with it I even forget it, but the next day when I start or when I navigate to another window and it is reversed, it is always a small annoyance.

If I move on the touchpad with two fingers I expect the text to move "in that direction", just as on an (Android) smartphone. It is as if I touch the screen/paper and move it up. That there is a cursor on theleft side moving in the opposite direction I don't care about. Especially in the browser!

Anyway, this can be set by something like:

```
xinput list
xinput list-props 16 # for example
xinput --set-prop 16 'libinput Natural Scrolling Enabled' 1
```

To make this permanent, add to `/usr/share/X11/xorg.conf.d/40-libinput.conf`:

```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "NaturalScrolling" "on"
        Option "Tapping" "on"
EndSection
```

Note that I also like to be able to click by tapping (rather than having to navigate to a separate button for that). Again, it's the same experience as on a smartphone.

This however will be overwritten when you go from one OS version to the next. Hence, what you can do:

```
cp /etc/X11/xinit/xinitrc ~/.xinitrc
vim ~/.xinitrc
```

And add the lines:

```
xinput --set-prop 13 'libinput Natural Scrolling Enabled' 1
xinput --set-prop 13 'libinput Tapping Enabled' 1
```

## Screenshots

For screenshots I'm using flameshot. This used to have a directory name as argument, but in that case the save to
clipboard button disappeared. Remove the argument.

```
bindsym Print exec flameshot gui -p ~/pictures/screenshots
```

## Pdf viewer

Zathura can open in shell

```
sudo apt install zathura
```

To configure as default application:

```
mimeopen -d some.pdf
```

## Firefox

Firefox might need some post-install love.
Run `firefox -safe-mode` to get some more error messages when things go wrong.
For example, if there is no upload dialog, run the following:

```
sudo apt install xdg-desktop-portal xdg-desktop-portal-gtk
```


