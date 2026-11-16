local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local translatorForPlayer = nil
local localPlayer = nil
local localeId = nil
local localeIdChangedConnection = nil
local bindableEvent = Instance.new("BindableEvent")

local function handlePlayerOrLocaleChanged() -- 1 equivalent call inferred from this helper
	if localPlayer and localPlayer.LocaleId ~= localeId then
		localeId = localPlayer.LocaleId
		bindableEvent:Fire(localeId)
	end
end

local function reset() -- 1 equivalent call inferred from this helper
	translatorForPlayer = nil
	localPlayer = nil

	if localeIdChangedConnection then
		localeIdChangedConnection:Disconnect()
		localeIdChangedConnection = nil
	end
end

local function getTranslator() -- 2 equivalent calls inferred from this helper
	if translatorForPlayer then
		return translatorForPlayer
	end

	localPlayer = Players.LocalPlayer

	if localPlayer then
		translatorForPlayer = LocalizationService:GetTranslatorForPlayer(localPlayer)
		handlePlayerOrLocaleChanged() -- inferred equivalent call
		localeIdChangedConnection = localPlayer:GetPropertyChangedSignal("LocaleId"):Connect(handlePlayerOrLocaleChanged)
	end

	return translatorForPlayer
end

local v = {}

local function unregisterGui(descendant) -- 1 equivalent call inferred from this helper
	local v2 = v[descendant]

	if not v2 then
		return
	end

	v2.connection:Disconnect()
	v[descendant] = nil
end

local function makeAncestryChangedHandler(descendant, registryInfo) -- 1 equivalent call inferred from this helper
	return function(_, _)
		if game:IsAncestorOf(descendant) then
			registryInfo.hasBeenAdded = true
		elseif registryInfo.hasBeenAdded then
			unregisterGui(descendant) -- inferred equivalent call
		end
	end
end

local function updateRegistryInfo(p, context, text) -- 2 equivalent calls inferred from this helper
	p.context = context
	p.text = text
end

local function makeRegistryInfo(descendant, context, text)
	local registryInfo = { hasBeenAdded = game:IsAncestorOf(descendant) }
	updateRegistryInfo(registryInfo, context, text) -- inferred equivalent call
	registryInfo.connection = descendant.AncestryChanged:Connect(makeAncestryChangedHandler(descendant, registryInfo)) -- inferred equivalent call

	return registryInfo
end

local function registerGui(p, context, text) -- 1 equivalent call inferred from this helper
	if v[p] == nil then
		v[p] = makeRegistryInfo(p, context, text)
		return
	end

	updateRegistryInfo(v[p], context, text) -- inferred equivalent call
end

Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
	reset() -- inferred equivalent call
	getTranslator() -- inferred equivalent call
end)

local GameTranslator = {}

GameTranslator.LocaleChanged = bindableEvent.Event

function GameTranslator:TranslateGameText(p, p2)
	local translator = getTranslator() -- inferred equivalent call

	if translator then
		return translator:RobloxOnlyTranslate(p, p2)
	end

	return p2
end

local function retranslateAll()
	for k, v2 in pairs(v) do
		k.Text = GameTranslator:TranslateGameText(v2.context, v2.text)
	end
end

LocalizationService.AutoTranslateWillRun:Connect(retranslateAll)

function GameTranslator.TranslateAndRegister(object, p, context, text)
	p.Text = object:TranslateGameText(context, text)
	registerGui(p, context, text) -- inferred equivalent call
	return text
end

return GameTranslator
