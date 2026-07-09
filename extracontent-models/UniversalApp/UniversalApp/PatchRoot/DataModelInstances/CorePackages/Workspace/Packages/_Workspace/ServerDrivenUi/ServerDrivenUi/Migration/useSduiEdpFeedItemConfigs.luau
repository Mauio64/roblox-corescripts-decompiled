local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiComponent = SduiCoreSystem.SduiComponent
local SduiErrors = SduiCoreSystem.SduiErrors

require(ServerDrivenUiParent.Signals)

local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local getSduiFeedStore = require(ServerDrivenUi.DataStore.getSduiFeedStore)

require(ServerDrivenUi.DataStore.SduiFeedStoreTypes)

local FFlagSduiGetItemCollectionKeys = require(ServerDrivenUi.Flags).FFlagSduiGetItemCollectionKeys

local function getLayoutOrder(n1: number?, n2: number, t1: {[any]: any}, s1: string, p1: ((...any) -> ...any)) -- line: 30
	if n1 and t1[n1] then
		p1({
			layoutOrder = n1,
			itemKey = s1,
			existingComponent = t1[n1]
		})

		return n2
	end

	if n1 then
		return n1
	end

	return n2
end
local function useSduiEdpFeedItemConfigs(t2: {[any]: any}) -- line: 67
	-- upvalues: React (copy), getSduiFeedStore (copy), FFlagSduiGetItemCollectionKeys (copy), SignalsReact (copy), SduiErrors (copy), SduiComponent (copy)
	local v18 = React.useMemo(function() -- line: 68
		-- upvalues: t2 (copy), getSduiFeedStore (copy), FFlagSduiGetItemCollectionKeys (copy)
		return function(p2) -- line: 69
			-- upvalues: t2 (copy), getSduiFeedStore (copy), FFlagSduiGetItemCollectionKeys (copy)
			if not t2.shouldInterleaveSdui then
				return {}
			end

			local v47 = getSduiFeedStore(t2.storeKey)
			local t3 = {}

			for _, v50 in if not FFlagSduiGetItemCollectionKeys or not v47.getItemCollectionKeys then {} else v47.getItemCollectionKeys(p2) do
				local v51 = v47.getItemCollection(v50)

				if v51 then
					t3[v50] = v51(p2)
				end
			end

			return t3
		end
	end, {
		t2.storeKey,
		t2.shouldInterleaveSdui
	})
	local v19 = SignalsReact.useSignalState(v18)
	local v20 = React.useMemo(function() -- line: 92
		-- upvalues: t2 (copy)
		local t4 = {}

		if not t2.shouldInterleaveSdui then
			return t4
		end

		for v24, v25 in t2.portraitLayoutConfig do
			t4[v25] = v24
		end

		return t4
	end, {
		t2.portraitLayoutConfig,
		t2.shouldInterleaveSdui
	})
	local v21 = React.useMemo(function() -- line: 103
		-- upvalues: t2 (copy)
		local t5 = {}

		if not t2.shouldInterleaveSdui then
			return t5
		end

		for v27, v28 in t2.landscapeLayoutConfig do
			t5[v28] = v27
		end

		return t5
	end, {
		t2.landscapeLayoutConfig,
		t2.shouldInterleaveSdui
	})
	local v22 = React.useCallback(function(p3, s2: string, n3: number) -- line: 115
		-- upvalues: t2 (copy), v20 (copy), v21 (copy)
		if not t2.shouldInterleaveSdui then
			return {}
		end

		local v32 = p3.sduiConfig and (p3.sduiConfig.props and p3.sduiConfig.props.LayoutOrder)
		local v33 = t2.defaultLayoutOrder + n3
		local v34 = v20
		local logLayoutConflictFn = t2.logLayoutConflictFn
		local v36

		if v32 and v34[v32] then
			logLayoutConflictFn({
				layoutOrder = v32,
				itemKey = s2,
				existingComponent = v34[v32]
			})
			v36 = v33
		else
			v36 = v32 or v33
		end

		local v37 = v21
		local logLayoutConflictFn2 = t2.logLayoutConflictFn

		if v32 and v37[v32] then
			logLayoutConflictFn2({
				layoutOrder = v32,
				itemKey = s2,
				existingComponent = v37[v32]
			})
		else
			v33 = v32 or v33
		end

		return {
			portrait = v36,
			landscape = v33
		}
	end, {
		v21,
		v20,
		t2.defaultLayoutOrder,
		t2.logLayoutConflictFn,
		t2.shouldInterleaveSdui
	})

	return React.useMemo(function() -- line: 156
		-- upvalues: t2 (copy), v19 (copy), v22 (copy), SduiErrors (copy), React (copy), SduiComponent (copy)
		if not t2.shouldInterleaveSdui then
			return {}
		end

		local t6 = {}
		local n4 = 0

		for v41, v42 in v19 do
			local v43 = v22(v42, v41, n4)

			n4 += 1

			local v44 = v42 and v42.sduiConfig or nil
			local v45 = `SduiEdpFeedItem-{ t2.storeKey }-{ v41 }`

			if v44 == nil then
				t2.sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentConfig, {
					name = v45,
					message = `Unable to render edp feed item for sdui. Feed store key: { t2.storeKey }, Collection key: { v41 }`
				}, t2.sduiContext.appPage)
			else
				t6[v41] = {
					portraitLayoutOrder = v43.portrait,
					landscapeLayoutOrder = v43.landscape,
					renderComponent = function() -- line: 179
						-- upvalues: React (copy), SduiComponent (copy), v45 (copy), v44 (copy), t2 (copy)
						return React.createElement(SduiComponent, {
							debugName = v45,
							componentConfig = v44,
							sduiContext = t2.sduiContext
						})
					end
				}
			end
		end

		return t6
	end, {
		v19,
		t2.storeKey,
		t2.sduiContext,
		v22,
		t2.shouldInterleaveSdui
	})
end

return useSduiEdpFeedItemConfigs
