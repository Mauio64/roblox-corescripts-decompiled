local CoreGui = game:GetService("CoreGui")
local scriptParent = script.Parent
local UIBlox = require(scriptParent.UIBlox)
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(scriptParent.InExperienceLocales).Localization
local LocalizationProvider = require(scriptParent.Localization).LocalizationProvider
local Images = UIBlox.App.ImageSet.Images
local NotificationModalsManager = require(scriptParent.NotificationModalsManager)
local Roact = require(scriptParent.Roact)
local Foundation = require(scriptParent.Foundation)
local AppStyleProvider = require(scriptParent.UIBlox).App.Style.AppStyleProvider
local LayerCollectorProvider = require(scriptParent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local InExperienceInterventionContainer = require(script.InExperienceInterventionContainer)
local FoundationProvider = Foundation.FoundationProvider
local InterventionPlacement = require(scriptParent.InterventionShared).Contexts.InterventionPlacement
local Constants = require(scriptParent.InterventionShared).Utils.Constants
local t1 = {}
local v19 = game:DefineFastFlag("FFlagTimeoutRemoteEvent", false)
local v20 = game:DefineFastInt("InExperienceInterventionDisplayOrder", 6)

if v19 then
	RobloxReplicatedStorage:WaitForChild("TimeoutChatAttempt", 1e999).OnClientEvent:Connect(function(p1, p2) -- line: 31
		-- upvalues: NotificationModalsManager (copy), Images (copy)
		NotificationModalsManager.SetUIBloxToast({
			toastTitle = "Test Chat Timeout RemoteEvent",
			iconImage = Images["icons/status/error_large"],
			toastSubtitle = `startTime: { p1 }, duration: { p2 }`,
			sequenceNumber = DateTime.now().UnixTimestamp,
			iconSize = Vector2.new(36, 36)
		})
	end)
end

function t1.new() -- line: 42
	-- upvalues: t1 (copy), Roact (copy), v20 (copy), LayerCollectorProvider (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), InterventionPlacement (copy), Constants (copy), FoundationProvider (copy), AppStyleProvider (copy), InExperienceInterventionContainer (copy), CoreGui (copy)
	local self = setmetatable({}, t1)

	self.root = Roact.createElement("ScreenGui", {
		DisplayOrder = v20
	}, {
		LayerCollectorProvider = Roact.createElement(LayerCollectorProvider, {}, {
			LocalizationProvider = Roact.createElement(LocalizationProvider, {
				localization = Localization.new(LocalizationService.RobloxLocaleId)
			}, {
				InterventionPlacementProvider = Roact.createElement(InterventionPlacement.Provider, {
					value = Constants.InterventionPlacementType.InExperience
				}, {
					FoundationProvider = Roact.createElement(FoundationProvider, {
						theme = "Dark"
					}, {
						StyleProvider = Roact.createElement(AppStyleProvider, {
							style = {
								themeName = "dark",
								fontName = "gotham"
							}
						}, {
							Container = Roact.createElement(InExperienceInterventionContainer, {})
						})
					})
				})
			})
		})
	})
	self.element = Roact.mount(self.root, CoreGui, "InExperienceInterventionApp")

	return self
end

return t1.new()
