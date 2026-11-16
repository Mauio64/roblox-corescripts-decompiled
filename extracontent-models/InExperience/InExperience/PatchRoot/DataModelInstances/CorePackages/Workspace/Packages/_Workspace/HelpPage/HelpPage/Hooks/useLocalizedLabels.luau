local parent = script.Parent.Parent
local parent2 = parent.Parent

local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local React = require(parent2.React)
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationRoactContext = Localization.LocalizationRoactContext
local FFlagHelpPageCCL = require(parent.Flags.FFlagHelpPageCCL)

local function useTranslator()
	local state, setState = React.useState(nil)

	React.useEffect(function()
		local localPlayer = Players.LocalPlayer

		if localPlayer == nil then
			return
		end

		local v = false
		task.spawn(function()
			local success, result = pcall(function()
				return LocalizationService:GetTranslatorForPlayerAsync(localPlayer)
			end)

			if success and not v then
				setState(result)
			end
		end)

		return function()
			v = true
		end
	end, {})

	return state
end

local function getExperienceLocalizedLabel(object, item: string)
	local success, result = pcall(function()
		return object:FormatByKey(item)
	end)

	if success and type(result) == "string" and result ~= "" then
		return result
	end

	local success2, result2 = pcall(function()
		return object:Translate(game, item)
	end)

	if success2 and type(result2) == "string" and result2 ~= "" then
		return result2
	end

	return nil
end

local function useLocalizedLabels(items, p)
	if not FFlagHelpPageCCL then
		return useLocalization(items)
	end

	local v = React.useContext(LocalizationRoactContext)
	local genericAction = useLocalization({ genericAction = "InGame.HelpMenu.GenericAction" }).genericAction
	local v2 = useTranslator()
	local v3 = p or v2
	local result = {}

	for k, item in items do
		if item == "" then
			result[k] = genericAction
		else
			local success, result2 = pcall(function()
				return v:Format(item)
			end)

			if success and type(result2) == "string" and result2 ~= "" then
				result[k] = result2
			else
				if v3 ~= nil then
					local experienceLocalizedLabel = getExperienceLocalizedLabel(v3, item)

					if experienceLocalizedLabel ~= nil then
						result[k] = experienceLocalizedLabel
						continue
					end
				end

				result[k] = item
			end
		end
	end

	return result
end

return useLocalizedLabels
