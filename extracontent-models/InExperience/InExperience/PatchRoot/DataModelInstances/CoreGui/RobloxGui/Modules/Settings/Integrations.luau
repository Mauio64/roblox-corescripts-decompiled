local Settings = script:FindFirstAncestor("Settings")
local FFlagRefactorInExpSettingsInDevelopment = require(Settings.Flags).FFlagRefactorInExpSettingsInDevelopment
local Integrations = Settings.Integrations
local Settings2 = nil

if FFlagRefactorInExpSettingsInDevelopment then
	Settings2 = require(Integrations.Settings)
end

local Constants = require(Integrations.Constants)
local Utils = require(Integrations.Utils)

return {
	Settings = Settings2,
	Constants = Constants,
	Utils = Utils
}
