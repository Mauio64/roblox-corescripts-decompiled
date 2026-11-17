local SharedFlags = require(script.Parent.SharedFlags)
local SduiV2 = require(script.SduiV2)
local PromptsHandler = require(script.SduiV2.PromptsHandler)

local FFlagLuaAppsServerTriggeredModals = SharedFlags.FFlagLuaAppsServerTriggeredModals
local FFlagEnableProfileCompletion = SharedFlags.FFlagEnableProfileCompletion
local FFlagEnableSduiV2HomepagePrompts = SharedFlags.FFlagEnableSduiV2HomepagePrompts
local FFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags.FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsHandlerEnabled = SharedFlags.FFlagPromptsHandlerEnabled
local FFlagEdpGameLeavePromptsHandlerEnabled = SharedFlags.FFlagEdpGameLeavePromptsHandlerEnabled
local FFlagEdpOpenPromptsHandlerEnabled = SharedFlags.FFlagEdpOpenPromptsHandlerEnabled
local FFlagChatPushUpsellPromptsEnabled = SharedFlags.FFlagChatPushUpsellPromptsEnabled
local FFlagNotificationStreamPromptsHandlerEnabled = SharedFlags.FFlagNotificationStreamPromptsHandlerEnabled

local ServerTriggeredModals = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"]
}
local checkForSduiModal

if FFlagLuaAppsServerTriggeredModals then
	checkForSduiModal = require(script.CheckForSduiModal)
end

ServerTriggeredModals.CheckForSduiModal = checkForSduiModal
local sduiModal

if FFlagLuaAppsServerTriggeredModals then
	sduiModal = require(script.SduiModal)
end

ServerTriggeredModals.SduiModal = sduiModal
local promptsContainer

if FFlagEnableSduiV2HomepagePrompts or FFlagPromptsHandlerEnabled then
	promptsContainer = require(script.PromptsContainer)
end

ServerTriggeredModals.PromptsContainer = promptsContainer
local checkForPrompts

if FFlagEnableSduiV2HomepagePrompts then
	checkForPrompts = require(script.CheckForPrompts)
end

ServerTriggeredModals.CheckForPrompts = checkForPrompts
ServerTriggeredModals.PromptsConstants = require(script.PromptsConstants)
local fetchPrompts

if FFlagEnableProfileCompletion or FFlagPromptsHandlerEnabled then
	fetchPrompts = SduiV2.fetchPrompts
end

ServerTriggeredModals.fetchPrompts = fetchPrompts
local promptsEntryPoint

if FFlagEnableProfileCompletion or FFlagPromptsHandlerEnabled then
	promptsEntryPoint = SduiV2.PromptsEntryPoint
end

ServerTriggeredModals.PromptsEntryPoint = promptsEntryPoint
local promptStyle

if FFlagEnableHomepagePromptsForModalsAndBanners or FFlagPromptsHandlerEnabled then
	promptStyle = SduiV2.PromptStyle
end

ServerTriggeredModals.PromptStyle = promptStyle
local usePromptEntries

if FFlagEnableHomepagePromptsForModalsAndBanners then
	usePromptEntries = SduiV2.usePromptEntries
end

ServerTriggeredModals.usePromptEntries = usePromptEntries
local promptsSystemBanner

if FFlagEnableHomepagePromptsForModalsAndBanners then
	promptsSystemBanner = require(script.PromptsSystemBanner)
end

ServerTriggeredModals.PromptsSystemBanner = promptsSystemBanner
local reportPromptImpression

if FFlagEnableProfileCompletion then
	reportPromptImpression = require(script.reportPromptImpression)
end

ServerTriggeredModals.reportPromptImpression = reportPromptImpression
local promptsHandler

if FFlagPromptsHandlerEnabled then
	promptsHandler = PromptsHandler.PromptsHandler
end

ServerTriggeredModals.PromptsHandler = promptsHandler
local edpGameLeavePromptsHandler

if FFlagEdpGameLeavePromptsHandlerEnabled then
	edpGameLeavePromptsHandler = require(script.SduiV2.EdpGameLeavePromptsHandler)
end

ServerTriggeredModals.EdpGameLeavePromptsHandler = edpGameLeavePromptsHandler
local edpOpenPromptsHandler

if FFlagEdpOpenPromptsHandlerEnabled then
	edpOpenPromptsHandler = require(script.SduiV2.EdpOpenPromptsHandler)
end

ServerTriggeredModals.EdpOpenPromptsHandler = edpOpenPromptsHandler
local chatPromptsHandler

if FFlagChatPushUpsellPromptsEnabled then
	chatPromptsHandler = require(script.SduiV2.ChatPromptsHandler)
end

ServerTriggeredModals.ChatPromptsHandler = chatPromptsHandler
local streamPromptsHandler

if FFlagNotificationStreamPromptsHandlerEnabled then
	streamPromptsHandler = require(script.SduiV2.StreamPromptsHandler)
end

ServerTriggeredModals.StreamPromptsHandler = streamPromptsHandler
return ServerTriggeredModals
