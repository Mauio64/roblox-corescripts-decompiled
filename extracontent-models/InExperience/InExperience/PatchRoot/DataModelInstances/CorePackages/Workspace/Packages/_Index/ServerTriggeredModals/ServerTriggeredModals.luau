local SharedFlags = require(script.Parent.SharedFlags)
local SduiV2 = require(script.SduiV2)
local PromptsHandler = require(script.SduiV2.PromptsHandler)
local FFlagLuaAppsServerTriggeredModals = SharedFlags.FFlagLuaAppsServerTriggeredModals
local FFlagEnableProfileCompletion = SharedFlags.FFlagEnableProfileCompletion
local FFlagEnableSduiV2HomepagePrompts = SharedFlags.FFlagEnableSduiV2HomepagePrompts
local FFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsHandlerEnabled = SharedFlags.FFlagPromptsHandlerEnabled

return {
	["jest.config"] = script["jest.config"],
	CheckForSduiModal = if not FFlagLuaAppsServerTriggeredModals then nil else require(script.CheckForSduiModal),
	SduiModal = if not FFlagLuaAppsServerTriggeredModals then nil else require(script.SduiModal),
	PromptsContainer = if not FFlagEnableSduiV2HomepagePrompts and not FFlagPromptsHandlerEnabled then nil else require(script.PromptsContainer),
	CheckForPrompts = if not FFlagEnableSduiV2HomepagePrompts then nil else require(script.CheckForPrompts),
	PromptsConstants = require(script.PromptsConstants),
	fetchPrompts = if not FFlagEnableProfileCompletion and not FFlagPromptsHandlerEnabled then nil else SduiV2.fetchPrompts,
	PromptsEntryPoint = if not FFlagEnableProfileCompletion and not FFlagPromptsHandlerEnabled then nil else SduiV2.PromptsEntryPoint,
	PromptStyle = if not FFlagEnableHomepagePromptsForModalsAndBanners and not FFlagPromptsHandlerEnabled then nil else SduiV2.PromptStyle,
	usePromptEntries = if not FFlagEnableHomepagePromptsForModalsAndBanners then nil else SduiV2.usePromptEntries,
	PromptsSystemBanner = if not FFlagEnableHomepagePromptsForModalsAndBanners then nil else require(script.PromptsSystemBanner),
	reportPromptImpression = if not FFlagEnableProfileCompletion then nil else require(script.reportPromptImpression),
	PromptsHandler = if not FFlagPromptsHandlerEnabled then nil else PromptsHandler.PromptsHandler
}
