local UserGameSettings = UserSettings():GetService("UserGameSettings")

return not UserGameSettings.ReducedMotion and game:DefineFastFlag("AXCategoryPillColorAnimation", false)
