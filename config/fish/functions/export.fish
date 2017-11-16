function export --description 'Set env variable. Alias for `set -gx` for bash compatibility.'
    if not set -q argv[1]
        set -x
        return 0
    end
    for arg in $argv
        set -l v (string split -m 1 "=" -- $arg)
        switch (count $v)
            case 0
            case 1
                set -gx $v $$v
            case 2
                if contains -- $v[1] PATH CDPATH MANPATH
                    set -l colonized_path (string replace -- "$$v[1]" (string join ":" -- $$v[1]) $v[2])
                    set -gx $v[1] (string split ":" -- $colonized_path)
                else
                    set -gx $v[1] $v[2]
                end
            case '*'
              set -gx $v[1] "$v[2..-1]"
        end
    end
end
