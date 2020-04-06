-- register default key bindings before using update() to apply overrides
dopath("cfg_defaults")

-- local f = io.open("/tmp/lua.txt", "w")
-- f:write("start debug logs\n")

XTERM="uxterm"

ioncore.set{
    warp=false,
    window_dialog_float=true,
}

-- update bindings without clobbering existing state; use this function to
-- avoid deep-copying all of /etc/notion/cfg_*.lua into $HOME/.notion
local function update(section, overrides)
    bindings = table.copy(ioncore.getbindings(), true)
    for _, tuple in ipairs(overrides) do
        keyspec = tuple[1]
        -- unregister existing uses of this keyspec from all sections
        for _, blob in pairs(bindings) do
            for idx, bind in ipairs(blob) do
                if bind.kcb == keyspec then
                    blob[idx] = kpress(keyspec, nil)
                end
            end
        end
        -- add keyspec to desired section
        k = kpress(keyspec, tuple[2], tuple[3])
        table.insert(bindings[section], k)
    end
    for a, b in pairs(bindings) do
        ioncore.defbindings(a, b)
    end
end

update("WScreen", {
    {
        META.."L", "ioncore.goto_next(_chld, 'right')", "_chld:non-nil"
    },
    {
        META.."H", "ioncore.goto_next(_chld, 'left')", "_chld:non-nil"
    },
})

update("WTiling", {
    {
        -- remove dangerous binding for destroying a split
        META.."X", nil
    },
    {
        META.."J", "ioncore.goto_next(_sub, 'down', {no_ascend=_})"
    },
    {
        META.."K", "ioncore.goto_next(_sub, 'up', {no_ascend=_})"
    },
})

update("WFrame.toplevel", {
    {
        META.."I", "WFrame.switch_next(_)"
    },
    {
        META.."U", "WFrame.switch_prev(_)"
    },
})

update("WGroupCW", {
    {
        META.."Return", "WGroup.set_fullscreen(_, 'toggle')"
    },
})

-- f:close()
