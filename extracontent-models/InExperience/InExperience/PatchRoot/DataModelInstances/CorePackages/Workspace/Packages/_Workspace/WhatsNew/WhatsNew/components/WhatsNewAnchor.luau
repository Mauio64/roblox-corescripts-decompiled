local WhatsNew = script:FindFirstAncestor("WhatsNew")
local parent = WhatsNew.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)

local View = Foundation.View

local function isGuiObjectReady(p): boolean -- 1 equivalent call inferred from this helper
	local absoluteSize = p.AbsoluteSize
	return absoluteSize.X > 0 and absoluteSize.Y > 0
end

local function WhatsNewAnchor(props)
	local whatsNewStore = GetWhatsNewStore()
	local anchorId = props.anchorId
	local ref = React.useRef(nil)

	local v = React.useCallback(function(p)
		if p == nil then
			return
		end

		whatsNewStore.setAnchorReady(anchorId, isGuiObjectReady(p), p) -- inferred equivalent call
	end, { whatsNewStore, anchorId })

	local ref2 = React.useCallback(function(current)
		if current == nil then
			local current2 = ref.current
			ref.current = nil

			if current2 ~= nil then
				whatsNewStore.unregisterAnchor(anchorId, current2)
			end
		else
			ref.current = current
			whatsNewStore.registerAnchor(anchorId, current)

			if whatsNewStore.getAnchorRef(anchorId) == current then
				v(current)
			end
		end
	end, { whatsNewStore, anchorId, v })

	React.useEffect(function()
		return function()
			whatsNewStore.unregisterAnchor(anchorId, ref.current)
		end
	end, { whatsNewStore, anchorId })

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v(p)
	end, { v })

	return React.createElement(View, {
		ref = ref2,
		tag = props.tag or "size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged
	}, props.children)
end

return React.memo(WhatsNewAnchor)
