local C = require("conf.constants")

-- Fallback for any unspecified monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

hl.monitor({
    output = "eDP-1",
    mode = "2944x1840@90.00",
    scale = 1.6,
    bitdepth = 10,
    cm = "dp3",
})
