import os

# pylint: disable=C0111
c = c  # type: ignore # noqa: F821 pylint: disable=E0602,C0103
config = config  # type: ignore # noqa: F821 pylint: disable=E0602,C0103

term = os.getenv("TERMINAL")

def bind_js(binding, js_name):
    dir_path = os.path.dirname(__file__)
    js_path = dir_path + "/js/" + js_name + ".js"
    file = open(js_path, "r")
    js_content = str(file.read())
    js_content = js_content.replace("\n", "")
    file.close()
    config.bind(binding, ("jseval " + js_content))

c.backend = 'webengine'
c.qt.args = [('ppapi-widevine-path='
              '/usr/lib/qt/plugins/ppapi/libwidevinecdmadapter.so')]
# /usr/share/qutebrowser/scripts/dictcli.py install pl-PL en-GB
c.spellcheck.languages = ['pl-PL', 'en-GB']
c.url.start_pages = ['http://localhost:46637']
c.url.default_page = 'http://localhost:46637'
# c.url.start_pages = ["https://duckduckgo.com/"]
# c.url.default_page = 'https://duckduckgo.com/'

c.fileselect.handler = "external"
c.fileselect.single_file.command = [term, "-t", "QB_FILE_SELECTION", "-e", "ranger", "--choosefile={}"]
c.fileselect.multiple_files.command = [term, "-t", "QB_FILE_SELECTION", "-e", "ranger", "--choosefiles={}"]

c.downloads.open_dispatcher = '/bin/bash -c "QB_DOWNLOAD_FILE=1 download-sort-and-open.sh \'{}\'"'
c.editor.command = [term, "-t", "NVIM_FOR_QB", "-e", "nvim", "{}"]
c.downloads.position = "bottom"
c.confirm_quit = ["multiple-tabs", "downloads"]
c.scrolling.bar = "always"
c.scrolling.smooth = True
c.prompt.radius = 5
c.tabs.background = True
c.tabs.last_close = "close"
c.tabs.show = "multiple"
c.tabs.position = "right"
c.tabs.width = 200
c.tabs.padding = {"top": 2, "bottom": 2, "left": 5, "right": 5}
c.downloads.location.directory = "~/Downloads"
# c.content.headers.user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36"
c.content.plugins = True
c.content.blocking.method = "both"
c.content.blocking.whitelist = [
    "piwik.org", "analytics.google.com", "apis.google.com", "thepiratebay.org",
    "googleadservices.com", "cache.addthiscdn.com"]
c.content.blocking.hosts.lists = [
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts",
    "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt",
    "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt",
    "http://storage.pbogut.me/cda.txt"]
c.content.pdfjs = False
c.hints.border = "1px solid #E3BE23"
c.hints.chars = "arstdhneifuwy"
# c.hints.find_implementation = "javascript"

c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = False

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "d":  "https://duckduckgo.com/?q={}",
    "s":  "https://www.startpage.com/do/asearch?q={}",
    "g":  "https://google.com/search?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "al": "https://allegro.pl/listing?string={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    # "th": "https://www.thingiverse.com/search?q={}",
    "at": "https://alternativeto.net/browse/search?q={}",
    "th":  "https://duckduckgo.com/?q={} site:thingiverse.com",
}
# c.colors.completion.even.bg = "#333333"
c.colors.completion.odd.bg = "#1f1f1f"
c.colors.completion.even.bg = "#1f1f1f"
c.colors.completion.category.bg = "#285577"
c.colors.completion.item.selected.fg = "white"
c.colors.completion.item.selected.bg = c.colors.completion.category.bg
c.colors.completion.item.selected.border.top = 'black'
c.colors.completion.item.selected.border.bottom = 'black'
c.colors.completion.scrollbar.fg = c.colors.completion.item.selected.bg
c.colors.statusbar.insert.bg = "#b58900"
c.colors.statusbar.caret.bg = "#d33682"
c.colors.statusbar.url.success.https.fg = "white"
c.colors.tabs.odd.bg = c.colors.completion.odd.bg
# c.colors.tabs.even.bg = c.colors.completion.even.bg
c.colors.tabs.even.bg = c.colors.completion.odd.bg
c.colors.tabs.selected.odd.bg = c.colors.completion.category.bg
c.colors.tabs.selected.even.bg = c.colors.completion.category.bg
c.colors.tabs.bar.bg = "#1c1c1c"
c.colors.messages.error.bg = "#dc322f"
c.colors.prompts.bg = c.colors.tabs.bar.bg
# c.fonts.monospace = ('"Sauce Code Pro Nerd Fonts", Terminus, Monospace, '
#                      '"DejaVu Sans Mono", Monaco, "Bitstream Vera Sans Mono", '
#                      '"Andale Mono", "Courier New", Courier, '
#                      '"Liberation Mono", monospace, Fixed, Consolas, Terminal')
c.fonts.hints = "12pt monospace"
c.fonts.prompts = "10pt sans-serif"
c.fonts.completion.entry = "8pt monospace"
c.fonts.completion.category = "bold 8pt monospace"
c.fonts.statusbar = "8pt monospace"
c.fonts.tabs.selected = "8pt monospace"
c.fonts.tabs.unselected = "8pt monospace"

config.unbind('<ctrl-v>', mode='normal')
config.unbind('d', mode='normal')
config.unbind('D', mode='normal')
config.unbind('T', mode='normal')
config.unbind('<back>', mode='normal')
config.bind('<ctrl-escape>', 'enter-mode passthrough', mode='normal')
config.bind('<ctrl-escape>', 'enter-mode normal', mode='passthrough')
config.bind('gP', 'open -p {url:pretty}')
config.bind('gp', 'set-cmd-text :open -p {url:pretty}')
config.bind('gO', 'set-cmd-text :open -t {url:pretty}')
config.bind('xO', 'set-cmd-text :open -b {url:pretty}')
config.bind('<Ctrl-q>', 'tab-close')
config.bind('<Ctrl-j>', 'tab-next')
config.bind('<Ctrl-k>', 'tab-prev')
config.bind('<Ctrl-n>', 'tab-next')
config.bind('<Ctrl-p>', 'tab-prev')
config.bind('<Ctrl-h>', 'fake-key <backspace>', mode='insert')
config.bind('<Ctrl-h>', 'rl-backward-delete-char', mode='command')
config.bind('<Return>', 'enter-mode insert')
config.bind('do', 'download-open')
config.bind('dc', 'download-clear')
config.bind('dr', 'download-remove')

config.bind('gc', 'spawn google-chrome-stable {url:pretty}')

config.bind('<Ctrl-i>', 'open-editor', mode='insert')
config.bind(
    '<ctrl-i>',
    'spawn --userscript ~/.scripts/keepass.rb --add', mode='insert')
config.bind(
    '<ctrl-l>',
    'spawn --userscript ~/.scripts/keepass.rb --type-user-and-pass',
    mode='insert')
config.bind(
    '<ctrl-u>',
    'spawn --userscript ~/.scripts/keepass.rb --type-user', mode='insert')
config.bind(
    '<ctrl-y>',
    'spawn --userscript ~/.scripts/keepass.rb --type-pass', mode='insert')
config.bind(
    '<ctrl-;>',
    'spawn --userscript ~/.scripts/keepass.rb --type-otpauth', mode='insert')


config.bind('<ctrl-j>', 'fake-key <down>', mode='insert')
config.bind('<ctrl-k>', 'fake-key <up>', mode='insert')
config.bind('<ctrl-n>', 'fake-key <down>', mode='insert')
config.bind('<ctrl-p>', 'fake-key <up>', mode='insert')
config.bind(
    '<ctrl-w>',
    'fake-key <shift-ctrl-left> ;; fake-key <backspace>', mode='insert')


config.bind('<Ctrl-j>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl-k>', 'completion-item-focus prev', mode='command')
config.bind('<Ctrl-n>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl-p>', 'completion-item-focus prev', mode='command')
config.bind(
    '<Ctrl-w>',
    'fake-key -g <shift-ctrl-left> ;; fake-key -g <backspace>', mode='command')

config.bind('<Alt-n>', 'command-history-next', mode='command')
config.bind('<Alt-j>', 'command-history-next', mode='command')
config.bind('<Alt-p>', 'command-history-prev', mode='command')
config.bind('<Alt-k>', 'command-history-prev', mode='command')

config.bind('K', 'tab-move -')
config.bind('J', 'tab-move +')

config.bind('M', 'spawn --userscript nextcloud --add-bookmark')
config.bind('b', 'spawn --userscript nextcloud --open-bookmark')
config.bind('B', 'spawn --userscript nextcloud --open-bookmark --new-tab')

config.bind('yh', 'spawn --userscript ~/.scripts/qb-copy-html.sh -b')
config.bind('ys', 'spawn --userscript ~/.scripts/qb-copy-text.sh -b')
config.bind('yH', 'spawn --userscript ~/.scripts/qb-copy-html.sh -p')
config.bind('yS', 'spawn --userscript ~/.scripts/qb-copy-text.sh -p')
config.bind('eu', 'edit-url')

config.bind('ds', 'open -t https://dissenter.com/discussion/begin?url={url}')

config.bind('gs', 'spawn --userscript ~/.scripts/qb-switch.sh')

config.bind('sje', 'set content.javascript.enabled true')
config.bind('sjd', 'set content.javascript.enabled false')

config.bind('es',  'spawn --userscript ~/.scripts/qb-switch-enviroment.php')

config.bind(',rm', 'spawn --userscript ~/.scripts/qb-url-to-remarkable.sh')
config.bind(',pdf', 'spawn --userscript ~/.scripts/qb-url-to-clean-pdf.sh')
config.bind(',tp', 'spawn --userscript ~/.scripts/qb-send-to-phone.sh')

config.bind(',xe', "jseval document.cookie = 'XDEBUG_SESSION=nvim-xdebug;'")
config.bind(',xd', "jseval document.cookie = `XDEBUG_SESSION=DISABLE; path=/; max-age=0;`;")

bind_js(',jpp', 'pixel_perfect')
bind_js(',jve', 'visual_event')
bind_js(',dd', 'developer_mode')

bind_js(',pp', 'pocket')
bind_js(',pt', 'pocket_tag')

dir_path = os.path.dirname(__file__)
if os.path.exists(dir_path + '/secure_config.py'):
    import secure_config # type: ignore
    secure_config.init(config)

# hackish way to change audio / mute icon
from qutebrowser.mainwindow import tabwidget
tabwidget.TabWidget.MUTE_STRING = " " # type: ignore
tabwidget.TabWidget.AUDIBLE_STRING = " " # type: ignore

# load yaml config
config.load_autoconfig()
