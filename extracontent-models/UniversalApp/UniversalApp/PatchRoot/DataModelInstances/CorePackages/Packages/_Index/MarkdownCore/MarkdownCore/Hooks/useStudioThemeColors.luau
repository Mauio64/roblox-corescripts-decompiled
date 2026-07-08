local Parent = script:FindFirstAncestor("Hooks").Parent
local React = require(Parent.Parent.React)
local Theme = require(Parent.Utils.Highlighter.Theme)

require(Parent.Types)

local isCli = require(Parent.Utils.isCli)

local function useStudioThemeColors() -- line: 8
	-- upvalues: React (copy), Theme (copy), isCli (copy)
	local v6, v7 = React.useState(Theme.defaultColors)

	React.useEffect(function() -- line: 11
		-- upvalues: isCli (copy), Theme (copy), v7 (copy)
		local function getTokens() -- line: 12
			-- upvalues: isCli (copy), Theme (copy)
			if isCli() then
				return Theme.defaultColors
			end

			local ok, result = pcall(function() -- line: 17
				return settings().Studio.Theme
			end)

			if not ok then
				return {}
			end

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

		v7((getTokens()))

		local ok, result = pcall(function() -- line: 40
			-- upvalues: v7 (copy), getTokens (copy)
			return settings().Studio.ThemeChanged:Connect(function() -- line: 41
				-- upvalues: v7 (copy), getTokens (copy)
				v7((getTokens()))
			end)
		end)

		return function() -- line: 46
			-- upvalues: ok (copy), result (copy)
			if ok and result then
				result:Disconnect()
			end
		end
	end, {})

	return v6
end

return useStudioThemeColors
