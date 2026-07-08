local scriptParent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Flags = require(Foundation.Utility.Flags)
local React = require(FoundationParent.React)

require(Foundation.Providers.Style.Tokens)
require(scriptParent.Rules.Types)

local createStyleSheetRules = require(scriptParent.createStyleSheetRules)
local getOverrideAttributes = require(scriptParent.getOverrideAttributes)
local useGeneratedRules = require(Foundation.Utility.useGeneratedRules)

require(Foundation.Enums.Device)
require(Foundation.Enums.Theme)

local function StyleSheet(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), useGeneratedRules (copy), Flags (copy), getOverrideAttributes (copy), createStyleSheetRules (copy)
	local v11, v12 = React.useState(nil)
	local v13 = React.useRef({})

	React.useLayoutEffect(function() -- line: 36
		-- upvalues: t1 (copy), v11 (copy)
		if t1.setStyleSheetRef and t1.setStyleSheetRef.current then
			t1.setStyleSheetRef.current(v11)
		end
	end, { v11 })

	local v14 = useGeneratedRules(t1.theme, t1.device)

	React.useLayoutEffect(function() -- line: 46
		-- upvalues: v11 (copy), Flags (copy), t1 (copy)
		if v11 and not Flags.FoundationDisableStyleProviderDerives then
			v11:SetDerives(t1.derives or {})
		end
	end, {
		v11,
		t1.derives
	})

	local v15 = React.useMemo(function() -- line: 53
		-- upvalues: getOverrideAttributes (copy), t1 (copy)
		return getOverrideAttributes(t1.theme, t1.device, t1.tokenOverrides)
	end, {
		t1.theme,
		t1.device,
		t1.tokenOverrides
	})
	local v16 = React.useMemo(function() -- line: 57
		-- upvalues: v11 (copy), createStyleSheetRules (copy), v14 (copy), t1 (copy), v13 (copy), v15 (copy)
		if v11 then
			return createStyleSheetRules(v14, t1.tags, v11, v13.current, t1.scale, v15)
		end

		return nil
	end, {
		v11,
		v14,
		t1.tags,
		t1.scale,
		v15
	})

	return React.createElement(React.Fragment, nil, {
		FoundationStyleSheet = React.createElement("StyleSheet", {
			ref = v12
		}, v16),
		FoundationStyleLink = React.createElement("StyleLink", {
			StyleSheet = v11
		})
	})
end

return React.memo(StyleSheet)
