local Settings = script:FindFirstAncestor("Settings")

local Flags = require(Settings.Flags)
local FFlagRefactorInExpSettingsInDevelopment = Flags.FFlagRefactorInExpSettingsInDevelopment

local integrations = Settings.Integrations
local Settings2

if FFlagRefactorInExpSettingsInDevelopment then
	Settings2 = require(integrations.Settings)
end

return {
	Settings = Settings2,
	Constants = require(integrations.Constants),
	Utils = require(integrations.Utils)
}
