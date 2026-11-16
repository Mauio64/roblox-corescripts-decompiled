local CoreGui = game:GetService("CoreGui")
local parent = script.Parent

local UIBlox = require(parent.UIBlox)
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local LocalizationService = game:GetService("LocalizationService")
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local Images = UIBlox.App.ImageSet.Images
local NotificationModalsManager = require(parent.NotificationModalsManager)
local Roact = require(parent.Roact)
local Foundation = require(parent.Foundation)
local UIBlox2 = require(parent.UIBlox)
local AppStyleProvider = UIBlox2.App.Style.AppStyleProvider
local UIBlox3 = require(parent.UIBlox)
local LayerCollectorProvider = UIBlox3.Core.Layout.LayerCollector.LayerCollectorProvider
local InExperienceInterventionContainer = require(script.InExperienceInterventionContainer)
local FoundationProvider = Foundation.FoundationProvider
local InterventionShared = require(parent.InterventionShared)
local InterventionPlacement = InterventionShared.Contexts.InterventionPlacement
local InterventionShared2 = require(parent.InterventionShared)
local Constants = InterventionShared2.Utils.Constants

local class = {}

local defineFastFlag = game:DefineFastFlag("FFlagTimeoutRemoteEvent", false)
local defineFastInt = game:DefineFastInt("InExperienceInterventionDisplayOrder", 6)

if defineFastFlag then
	RobloxReplicatedStorage:WaitForChild("TimeoutChatAttempt", 1e999).OnClientEvent:Connect(function(p, p2)
		NotificationModalsManager.SetUIBloxToast({
			iconImage = Images["icons/status/error_large"],
			toastTitle = "Test Chat Timeout RemoteEvent",
			toastSubtitle = `startTime: {p}, duration: {p2}`,
			sequenceNumber = DateTime.now().UnixTimestamp,
			iconSize = Vector2.new(36, 36)
		})
	end)
end

function class.new()
	local self = setmetatable({}, class)

	self.root = Roact.createElement("ScreenGui", { DisplayOrder = defineFastInt }, {
		LayerCollectorProvider = Roact.createElement(LayerCollectorProvider, {}, {
			LocalizationProvider = Roact.createElement(
				LocalizationProvider,
				{
					localization = Localization.new(LocalizationService.RobloxLocaleId)
				},
				{
					InterventionPlacementProvider = Roact.createElement(
						InterventionPlacement.Provider,
						{ value = Constants.InterventionPlacementType.InExperience },
						{
							FoundationProvider = Roact.createElement(FoundationProvider, {
								colorMode = "Dark"
							}, {
								StyleProvider = Roact.createElement(AppStyleProvider, {
									style = { themeName = "dark", fontName = "gotham" }
								}, {
									Container = Roact.createElement(InExperienceInterventionContainer, {})
								})
							})
						}
					)
				}
			)
		})
	})

	self.element = Roact.mount(self.root, CoreGui, "InExperienceInterventionApp")

	return self
end

return class.new()
