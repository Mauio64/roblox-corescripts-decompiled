local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local parent = script.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local ReactRoblox = require(parent2.ReactRoblox)
local Foundation = require(parent2.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Enums = Foundation.Enums

local AdLabel = require(parent.interactivity.AdLabel)

local InExperienceLocales = require(parent2.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local EnhancedVideoStore = require(parent.EnhancedVideoStore)

local dispatchEnhancedVideoConfig = require(parent.dispatchEnhancedVideoConfig)

local Http = require(parent2.Http)
local internalWrapper = Http.NetworkLayers.requestInternalWrapper(nil)
local function starterScript()
	if game.CreatorType ~= Enum.CreatorType.Group or game.CreatorId ~= 427968160 then
		return
	end

	local localization = Localization.new(LocalizationService.RobloxLocaleId)

	EnhancedVideoStore(false).fetchInitialData(internalWrapper, game.GameId):andThen(function(p)
		if p then
			dispatchEnhancedVideoConfig(p)
		end
	end)

	local adDisclosurePauseEvent = ReplicatedStorage:WaitForChild("AdDisclosurePauseEvent")

	local enhancedVideoInteractivityControls = Instance.new("Folder")
	enhancedVideoInteractivityControls.Name = "EnhancedVideoInteractivityControls"
	enhancedVideoInteractivityControls.Parent = CoreGui
	ReactRoblox.createRoot(enhancedVideoInteractivityControls):render(React.createElement("ScreenGui", {
		DisplayOrder = -5
	}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = localization
		}, {
			FoundationProvider = React.createElement(FoundationProvider, {
				colorMode = Enums.ColorMode.Dark
			}, {
				AdLabel = React.createElement(AdLabel, {
					sendPauseEvent = function()
						adDisclosurePauseEvent:Fire()
					end
				})
			})
		})
	}))
end

return starterScript
