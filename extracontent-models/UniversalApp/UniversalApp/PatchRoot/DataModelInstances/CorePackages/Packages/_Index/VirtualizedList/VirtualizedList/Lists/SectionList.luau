local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local _ = { OS = "roblox" }

local React = require(parent2.React)

local VirtualizedSectionList = require(script.Parent.VirtualizedSectionList)

require(parent.Components.ScrollView.ScrollView)

local extended = React.PureComponent:extend("SectionList")

function extended:init(props)
	self.props = props
	function self._captureRef(wrapperListRef)
		self._wrapperListRef = wrapperListRef
	end
end

function extended:scrollToLocation(p)
	if self._wrapperListRef ~= nil then
		self._wrapperListRef:scrollToLocation(p)
	end
end

function extended:recordInteraction()
	local v

	if self._wrapperListRef then
		v = self._wrapperListRef:getListRef()
	else
		v = self._wrapperListRef
	end

	if v then
		v:recordInteraction()
	end
end

function extended:flashScrollIndicators()
	local v

	if self._wrapperListRef then
		v = self._wrapperListRef:getListRef()
	else
		v = self._wrapperListRef
	end

	if v then
		v:flashScrollIndicators()
	end
end

function extended:getScrollResponder()
	local v

	if self._wrapperListRef then
		v = self._wrapperListRef:getListRef()
	else
		v = self._wrapperListRef
	end

	if Boolean.toJSBoolean(v) then
		return v:getScrollResponder()
	end

	return nil
end

function extended:getScrollableNode()
	local v

	if self._wrapperListRefthen then
		v = self._wrapperListRef:getListRef()
	else
		v = self._wrapperListRef
	end

	if Boolean.toJSBoolean(v) then
		return v:getScrollableNode()
	end

	return nil
end

function extended:setNativeProps(p)
	local v

	if self._wrapperListRef then
		v = self._wrapperListRef:getListRef()
	else
		v = self._wrapperListRef
	end

	if Boolean.toJSBoolean(v) then
		v:setNativeProps(p)
	end
end

function extended:render()
	local stickySectionHeadersEnabled = self.props.stickySectionHeadersEnabled
	local v = Object.assign({}, self.props, { stickySectionHeadersEnabled = Object.None })

	if stickySectionHeadersEnabled == nil then
		stickySectionHeadersEnabled = false
	end

	return React.createElement(VirtualizedSectionList, Object.assign({}, v, {
		stickySectionHeadersEnabled = stickySectionHeadersEnabled,
		ref = self._captureRef,
		getItemCount = function(list)
			return #list
		end,
		getItem = function(p, p2)
			return p[p2]
		end
	}))
end

return { default = extended }
