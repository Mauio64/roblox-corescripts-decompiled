local parent = script:FindFirstAncestor("Hooks").Parent

local React = require(parent.Parent.React)
local Theme = require(parent.Utils.Highlighter.Theme)
require(parent.Types)
local isCli = require(parent.Utils.isCli)

local function useStudioThemeColors()
	local state, setState = React.useState(Theme.defaultColors)

	React.useEffect(function()
		local function getTokens()
			if isCli() then
				return Theme.defaultColors
			end

			local success, result = pcall(function()
				return settings().Studio.Theme
			end)

			if success then
				return {
					background = result:GetColor(Enum.StudioStyleGuideColor.ScriptBackground),
					iden = result:GetColor(Enum.StudioStyleGuideColor.ScriptText),
					keyword = result:GetColor(Enum.StudioStyleGuideColor.ScriptKeyword),
					builtin = result:GetColor(Enum.StudioStyleGuideColor.ScriptBuiltInFunction),
					string = result:GetColor(Enum.StudioStyleGuideColor.ScriptString),
					number = result:GetColor(Enum.StudioStyleGuideColor.ScriptNumber),
					comment = result:GetColor(Enum.StudioStyleGuideColor.ScriptComment),
					operator = result:GetColor(Enum.StudioStyleGuideColor.ScriptOperator),
					custom = result:GetColor(Enum.StudioStyleGuideColor.ScriptBool)
				}
			end

			return {}
		end

		setState(getTokens())

		local success, result = pcall(function()
			return settings().Studio.ThemeChanged:Connect(function()
				setState(getTokens())
			end)
		end)

		return function()
			if success and result then
				result:Disconnect()
			end
		end
	end, {})

	return state
end

return useStudioThemeColors
