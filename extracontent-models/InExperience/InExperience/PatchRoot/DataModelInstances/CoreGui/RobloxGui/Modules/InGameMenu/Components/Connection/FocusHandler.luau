local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local Cryo = InGameMenuDependencies.Cryo
local GetFFlagIGMGamepadSelectionHistory = require(script.Parent.Parent.Parent.Flags.GetFFlagIGMGamepadSelectionHistory)
local FocusHandlerContext = require(script.Parent.FocusHandlerUtils.FocusHandlerContext)
local n1 = 1
local v9 = Roact.PureComponent:extend("FocusHandler")

v9.validateProps = t.strictInterface({
	isFocused = t.boolean,
	didFocus = t.optional(t.callback),
	didBlur = t.optional(t.callback),
	shouldForgetPreviousSelection = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.boolean) or nil,
	currentHandlerId = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.number) or nil,
	candidateHandlerId = GetFFlagIGMGamepadSelectionHistory() and t.optional(t.number) or nil,
	previousSelections = GetFFlagIGMGamepadSelectionHistory() and t.table or nil,
	requestFocusForHandlerId = GetFFlagIGMGamepadSelectionHistory() and t.callback or nil,
	forgetLastSelectionForHandlerId = GetFFlagIGMGamepadSelectionHistory() and t.callback or nil,
	blurCurrentFocusHandler = GetFFlagIGMGamepadSelectionHistory() and t.callback or nil,
	[Roact.Children] = t.optional(t.table)
})

if GetFFlagIGMGamepadSelectionHistory() then
	function v9.init(p1) -- line: 50
		-- upvalues: n1 (ref)
		p1.id = n1
		n1 += 1
	end
end

function v9.render(p2) -- line: 56
	-- upvalues: Roact (copy)
	return Roact.createFragment(p2.props[Roact.Children])
end

if GetFFlagIGMGamepadSelectionHistory() then
	function v9.didMount(p3) -- line: 61
		if p3.props.isFocused then
			p3.props.requestFocusForHandlerId(p3.id)
		end
	end
else
	function v9.didMount(p4) -- line: 67
		if p4.props.isFocused then
			p4.props.didFocus()
		end
	end
end

if GetFFlagIGMGamepadSelectionHistory() then
	function v9.didUpdate(p5, p6) -- line: 75
		local v17 = p5.props.shouldForgetPreviousSelection and not p6.shouldForgetPreviousSelection
		local v18 = p5.props.previousSelections[p5.id]

		if v17 or v18 ~= nil and not v18:IsDescendantOf(game) then
			p5.props.forgetLastSelectionForHandlerId(p5.id)
			v18 = nil
		end

		local v19 = p5.props.candidateHandlerId ~= p5.id and p5.props.candidateHandlerId ~= nil
		local v20 = p6.candidateHandlerId ~= p5.id and p6.candidateHandlerId ~= nil
		local v21 = p5.props.currentHandlerId == p5.id and p6.currentHandlerId ~= p5.id
		local v22 = p5.props.currentHandlerId == nil and (p6.currentHandlerId ~= nil and p6.currentHandlerId ~= p5.id) and (not v19 and p5.props.isFocused)
		local v23 = not p6.isFocused and p5.props.isFocused
		local v24 = p6.isFocused and not p5.props.isFocused or v19 and not v20
		local v25 = p6.currentHandlerId == p5.id and p5.props.currentHandlerId ~= p5.id

		if v23 or v22 then
			p5.props.requestFocusForHandlerId(p5.id)
		elseif v21 and p5.props.didFocus then
			p5.props.didFocus(v18)
		end

		if v24 and p5.props.currentHandlerId == p5.id then
			p5.props.blurCurrentFocusHandler(p5.id, p5.props.shouldForgetPreviousSelection)
		end

		if v25 and p5.props.didBlur then
			p5.props.didBlur()
		end
	end
else
	function v9.didUpdate(p7, p8) -- line: 135
		if p7.props.isFocused and (not p8.isFocused and p7.props.didFocus) then
			p7.props.didFocus()

			return
		end

		if not p7.props.isFocused and p8.isFocused and p7.props.didBlur then
			p7.props.didBlur()
		end
	end
end

if GetFFlagIGMGamepadSelectionHistory() then
	function v9.willUnmount(p9) -- line: 145
		if p9.props.isFocused then
			p9.props.blurCurrentFocusHandler(p9.id, true)

			if p9.props.didBlur then
				p9.props.didBlur()

				return
			end
		else
			p9.props.forgetLastSelectionForHandlerId(p9.id)
		end
	end
else
	function v9.willUnmount(p10) -- line: 156
		if p10.props.isFocused and p10.props.didBlur then
			p10.props.didBlur()
		end
	end
end

if GetFFlagIGMGamepadSelectionHistory() then
	local function FocusHandlerWithContext(p11) -- line: 164
		-- upvalues: Roact (copy), FocusHandlerContext (copy), v9 (copy), Cryo (copy)
		return Roact.createElement(FocusHandlerContext.Consumer, {
			render = function(p12) -- line: 166
				-- upvalues: Roact (copy), v9 (copy), Cryo (copy), p11 (copy)
				return Roact.createElement(v9, Cryo.Dictionary.join(p11, {
					currentHandlerId = p12.currentHandlerId,
					previousSelections = p12.previousSelections,
					requestFocusForHandlerId = p12.requestFocusForHandlerId,
					forgetLastSelectionForHandlerId = p12.forgetLastSelectionForHandlerId,
					blurCurrentFocusHandler = p12.blurCurrentFocusHandler,
					candidateHandlerId = p12.candidateHandlerId
				}))
			end
		})
	end

	return FocusHandlerWithContext
end

return v9
