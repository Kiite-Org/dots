local vars = require("variables")

hl.unbind("CTRL + SUPER + SHIFT + LEFT")
hl.unbind("CTRL + SUPER + SHIFT + RIGHT")
hl.unbind("CTRL + SUPER + SHIFT + DOWN")
hl.unbind("CTRL + SUPER + SHIFT + UP")

hl.unbind("SUPER + MINUS")
hl.unbind("SUPER + EQUAL")

hl.unbind(vars.kbClipboard)
hl.unbind(vars.kbEmoji)

hl.gesture({ fingers = vars.gestureFingers, direction = "up", action = "unset" })
hl.gesture({ fingers = vars.gestureFingersMore, direction = "down", action = "unset" })
