" switch between class and test file
let s:composer =
      \   {
      \     "*": {
      \       "project_root": 1
      \     },
      \   }
let s:laravel =
      \   {
      \     "*": {
      \       "logwatch": "tail -n 500 -f storage/logs/*.log"
      \     },
      \     "*.php": {
      \       "console": "php artisan tinker"
      \     },
      \     "app/*.php": {
      \       "alternate": [
      \         "tests/Unit/{}Test.php",
      \         "tests/Feature/{}Test.php"
      \       ],
      \       "skeleton": "laravel_class"
      \     },
      \     "app/Http/Controllers/*Controller.php": {
      \       "skeleton": "laravel_controller",
      \     },
      \     "tests/Unit/*Test.php": {
      \       "alternate": "app/{}.php",
      \       "skeleton": "laravel_test",
      \       "type": "test"
      \     },
      \     "tests/Feature/*Test.php": {
      \       "alternate": "app/{}.php",
      \       "skeleton": "laravel_test",
      \       "type": "test"
      \     },
      \   }
let s:elixir =
      \   {
      \     "lib/*.ex": {
      \       "alternate": "test/{}_test.exs"
      \     },
      \     "test/*_test.exs": {
      \       "alternate": "lib/{}.ex",
      \       "skeleton": "test",
      \       "type": "test",
      \     },
      \   }
let s:phoenixframework =
      \   {
      \     "*": {
      \       "start": "iex --sname phoenix -S mix phoenix.server",
      \       "console": "iex --sname relp",
      \     },
      \     "lib/*.ex": {
      \       "alternate": "test/{}_test.exs",
      \     },
      \     "web/*.ex": {
      \       "alternate": "test/{}_test.exs",
      \     },
      \     "test/*_test.exs": {
      \       "alternate": "web/{}.ex",
      \       "type": "test",
      \     },
      \     "test/controllers/*_test.exs": {
      \       "alternate": "web/controllers/{}.ex",
      \       "skeleton": "phoenix_test_controller",
      \       "type": "test",
      \     },
      \     "test/views/*_test.exs": {
      \       "alternate": "web/views/{}.ex",
      \       "skeleton": "phoenix_test_view",
      \       "type": "test",
      \     },
      \     "test/models/*_test.exs": {
      \       "alternate": "web/models/{}.ex",
      \       "skeleton": "phoenix_test_model",
      \       "type": "test",
      \     },
      \   }
let s:codeception =
      \   {
      \     "tests/unit/*Test.php": {
      \       "alternate": ["app/{}.php", "lib/{}.php"],
      \       "skeleton": "codeception_unit",
      \       "type": "test"
      \     },
      \     "tests/functional/*Cept.php": {
      \       "alternate": ["app/{}.php", "lib/{}.php"],
      \       "skeleton": "codeception_cept",
      \       "type": "test"
      \     },
      \     "tests/functional/*Cest.php": {
      \       "alternate": ["app/{}.php", "lib/{}.php"],
      \       "skeleton": "codeception_cest",
      \       "type": "test"
      \     },
      \     "tests/acceptance/*Cept.php": {
      \       "alternate": ["app/{}.php", "lib/{}.php"],
      \       "skeleton": "codeception_cept",
      \       "type": "test"
      \     },
      \     "tests/acceptance/*Cest.php": {
      \       "alternate": ["app/{}.php", "lib/{}.php"],
      \       "skeleton": "codeception_cest",
      \       "type": "test"
      \     },
      \     "app/*.php": {
      \       "alternate": [
      \         "tests/unit/{}Test.php",
      \         "tests/functional/{}Cest.php",
      \         "tests/functional/{}Cept.php",
      \         "tests/acceptance/{}Cest.php",
      \         "tests/acceptance/{}Cept.php",
      \       ]
      \     },
      \     "lib/*.php": {
      \       "alternate": ["tests/unit/{}Test.php", "tests/functional/{}Cept.php", "tests/functional/{}Cest.php"]
      \     },
      \   }
let g:projectionist_heuristics = {}
let g:projectionist_heuristics["composer.json"] = s:composer
let g:projectionist_heuristics["artisan&composer.json"] = s:laravel
let g:projectionist_heuristics["mix.exs"] = s:elixir
let g:projectionist_heuristics["mix.exs&web/"] = s:phoenixframework
let g:projectionist_heuristics["codeception.yml"] = s:codeception
