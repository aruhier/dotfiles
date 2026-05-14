-- 1:1 conversion from the hyprlang config.
local function hyprlang1to1()
    hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
    hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
    hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
    hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
    hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
    hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
    hl.curve("smoothIn", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })

    hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "default" })
    hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "easeOutQuint" })
    hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "easeOutQuint" })
    hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "easeOutQuint", style = "popin 87%" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "linear", style = "popin 87%" })
    hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "default", style = "slide" })
    hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "quick" })
    hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "almostLinear" })
    hl.animation({ leaf = "layers", enabled = true, speed = 1, bezier = "easeOutQuint" })
    hl.animation({ leaf = "layersIn", enabled = true, speed = 1, bezier = "easeOutQuint", style = "fade" })
    hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "linear", style = "fade" })
    hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2, bezier = "almostLinear" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "default", style = "slide" })
    hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1, bezier = "almostLinear", style = "fade" })
end

-- Bezier curves.
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeOutSmooth", { type = "bezier", points = { { 0.33, 1 }, { 0.68, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Spring curves.
-- binds.lua dynamically applies the 2 following animations. Sync both changes.
hl.curve("springSnappy", { type = "spring", mass = 0.6, stiffness = 80, dampening = 20 })
hl.curve("springSnappyDebounce", { type = "spring", mass = 3, stiffness = 110, dampening = 28 })
hl.curve("springBouncy", { type = "spring", mass = 1, stiffness = 100, dampening = 18 })
hl.curve("springSlide", { type = "spring", mass = 0.6, stiffness = 103, dampening = 26 })
-- Slightly less debounce than springSlide
hl.curve("springSlideSpecialWorkspace", { type = "spring", mass = 0.6, stiffness = 95, dampening = 22 })
hl.curve("springOut", { type = "spring", mass = 1, stiffness = 50, dampening = 25 })
hl.curve("springLayerOut", { type = "spring", mass = 0.6, stiffness = 27, dampening = 100 })

hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "easeOutQuint" })

-- Windows: spring for open/close/move
hl.animation({ leaf = "windows", enabled = true, speed = 2, spring = "springSnappy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, spring = "springBouncy", style = "popin 75%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, spring = "springOut", style = "popin 80%" })
-- binds.lua dynamically applies this animation. Sync both changes.
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1, spring = "springSnappy", style = "slide" })

-- Fade: keep bezier
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "almostLinear" })

-- Layers: spring for open, bezier for close
hl.animation({ leaf = "layers", enabled = true, speed = 2, bezier = "almostLinear" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2, spring = "springSnappy", style = "popin 90%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, spring = "springLayerOut", style = "popin 70%" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.75, bezier = "easeOutSmooth" })

-- Workspaces: spring for sliding
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, spring = "springSlide", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 2, spring = "springSlideSpecialWorkspace", style = "slide top" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2, spring = "springSlideSpecialWorkspace", style = "slide bottom" })
-- So that create_on_empty animation is consistent with the specialworkspace animation.
hl.window_rule({ match = { workspace = "s[true]" }, animation = "slide top" })

hl.layer_rule({ match = { namespace = "logout_dialog" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, animation = "slide right" })
