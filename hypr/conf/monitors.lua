local C = require("conf.constants")

-- Fallback for any unspecified monitor
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

hl.monitor({
    output = C.monitors.lg_27,
    mode = "preferred",
    position = "auto",
    bitdepth = 10,
    cm = "dp3",
    supports_hdr = -1,
})

hl.monitor({
    output = C.monitors.msi_32,
    mode = "3840x2160@239.99Hz",
    position = "auto",
    max_luminance = 500,
    max_avg_luminance = 500,
    sdr_max_luminance = 200,
})

hl.monitor({
    output = C.monitors.dell_27,
    mode = "2560x1440@59.95100Hz",
    position = "auto",
})
