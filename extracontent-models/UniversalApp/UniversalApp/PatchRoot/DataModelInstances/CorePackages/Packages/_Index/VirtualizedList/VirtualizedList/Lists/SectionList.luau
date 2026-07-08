local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local t1 = {}
local _ = {
	OS = "roblox"
}
local React = require(ParentParentParent.React)
local VirtualizedSectionList = require(script.Parent.VirtualizedSectionList)

require(ParentParent.Components.ScrollView.ScrollView)

local v10 = React.PureComponent:extend("SectionList")

function v10.init(p1, p2) -- line: 195
	p1.props = p2

	function p1._captureRef(p3) -- line: 197
		-- upvalues: p1 (copy)
		p1._wrapperListRef = p3
	end
end
function v10.scrollToLocation(p4, p5) -- line: 212
	if p4._wrapperListRef ~= nil then
		p4._wrapperListRef:scrollToLocation(p5)
	end
end
function v10.recordInteraction(p6) -- line: 225
	local v16 = if not p6._wrapperListRef then p6._wrapperListRef else p6._wrapperListRef:getListRef()

	if v16 then
		v16:recordInteraction()
	end
end
function v10.flashScrollIndicators(p7) -- line: 237
	local v18 = if not p7._wrapperListRef then p7._wrapperListRef else p7._wrapperListRef:getListRef()

	if v18 then
		v18:flashScrollIndicators()
	end
end
function v10.getScrollResponder(p8) -- line: 247
	-- upvalues: Boolean (copy)
	local v20 = if not p8._wrapperListRef then p8._wrapperListRef else p8._wrapperListRef:getListRef()

	if Boolean.toJSBoolean(v20) then
		return v20:getScrollResponder()
	end

	return nil
end
function v10.getScrollableNode(p9) -- line: 255
	-- upvalues: Boolean (copy)
	local v22 = if not p9._wrapperListRefthen then p9._wrapperListRef else p9._wrapperListRef:getListRef()

	if Boolean.toJSBoolean(v22) then
		return v22:getScrollableNode()
	end

	return nil
end
function v10.setNativeProps(p10, p11) -- line: 263
	-- upvalues: Boolean (copy)
	local v25 = if not p10._wrapperListRef then p10._wrapperListRef else p10._wrapperListRef:getListRef()

	if Boolean.toJSBoolean(v25) then
		v25:setNativeProps(p11)
	end
end
function v10.render(p12) -- line: 270
	-- upvalues: Object (copy), React (copy), VirtualizedSectionList (copy)
	local stickySectionHeadersEnabled = p12.props.stickySectionHeadersEnabled
	local v28 = Object.assign({}, p12.props, {
		stickySectionHeadersEnabled = Object.None
	})
	local v29 = stickySectionHeadersEnabled ~= nil and stickySectionHeadersEnabled

	return React.createElement(VirtualizedSectionList, Object.assign({}, v28, {
		stickySectionHeadersEnabled = v29,
		ref = p12._captureRef,
		getItemCount = function(p13) -- line: 282
			return #p13
		end,
		getItem = function(p14, p15) -- line: 285
			return p14[p15]
		end
	}))
end

t1.default = v10

return t1
