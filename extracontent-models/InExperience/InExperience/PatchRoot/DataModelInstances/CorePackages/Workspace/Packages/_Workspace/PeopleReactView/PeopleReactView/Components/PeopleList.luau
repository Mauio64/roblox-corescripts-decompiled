local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local Foundation = require(PeopleReactViewParent.Foundation)
local React = require(PeopleReactViewParent.React)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local View = Foundation.View
local useSignalState = SignalsReact.useSignalState
local PersonRow = require(PeopleReactView.Components.List.PersonRow)
local LazyPersonRow = require(PeopleReactView.Components.List.LazyPersonRow)

require(PeopleReactView.Stores.GetScrollingFrameStore)

local v11 = PeopleService.getService("Flags")
local GetFFlagAddPeoplePageCardLayout = v11.GetFFlagAddPeoplePageCardLayout
local FFlagEnablePeopleListLazyRender = v11.FFlagEnablePeopleListLazyRender

local function MemoizedPersonRow(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), FFlagEnablePeopleListLazyRender (copy), LazyPersonRow (copy), PersonRow (copy)
	return React.useMemo(function() -- line: 37
		-- upvalues: FFlagEnablePeopleListLazyRender (copy), React (copy), LazyPersonRow (copy), t1 (copy), PersonRow (copy)
		if FFlagEnablePeopleListLazyRender then
			return (React.createElement(LazyPersonRow, {
				key = tostring(t1.person.UserId),
				person = t1.person,
				layoutOrder = t1.index,
				scrollingFrameStore = t1.scrollingFrameStore
			}))
		end

		return (React.createElement(PersonRow, {
			key = tostring(t1.person.UserId),
			person = t1.person,
			layoutOrder = t1.index
		}))
	end, {
		t1.person.UserId,
		t1.index,
		t1.scrollingFrameStore
	})
end
local function buildPersonRows(t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}, p1) -- line: 57
	-- upvalues: React (copy), MemoizedPersonRow (copy), FFlagEnablePeopleListLazyRender (copy)
	local t5 = {}
	local t6 = {}
	local n1 = 0
	local g30 = nil
	local g34 = nil
	local UserId = nil
	local g31 = nil

	if not next(t4) then
		for v25, v26 in t2 do
			t4[v26.UserId] = (v25 - 1) * math.floor(100000 / #t2)
		end
	end

	for v27, v28 in t2 do
		if not t3[v28.UserId] then
			local n2 = 0

			repeat
				if g30 or v27 == 1 then
					g30 = false
					t5[v28.UserId] = React.createElement(MemoizedPersonRow, {
						person = v28,
						index = n2,
						scrollingFrameStore = if not FFlagEnablePeopleListLazyRender then nil else p1
					})
					t6[v28.UserId] = n2
					n1 = n2
					g31 = true

					break
				end

				local v32 = v27 + 1
				local n3 = 100000

				repeat
					while g34 or true do
						if g34 or not (v32 <= #t2) then
							g34 = false
							n2 = math.floor((n1 + n3) / 2)
							g30 = true
						end

						if g30 then
							break
						end

						UserId = t2[v32].UserId

						if t4[UserId] then
							break
						end

						v32 += 1
					end

					if g30 then
						break
					end

					n3 = t4[UserId]
					g34 = true
				until not g34
			until not g30

			if g31 then
				g31 = false

				continue
			end
		end

		t5[v28.UserId] = t3[v28.UserId]
		t6[v28.UserId] = t4[v28.UserId]
		n1 = t4[v28.UserId]
	end

	return t5, t6
end
local function PeopleList(t7: {[any]: any}) -- line: 122
	-- upvalues: React (copy), PeopleService (copy), useSignalState (copy), buildPersonRows (copy), FFlagEnablePeopleListLazyRender (copy), View (copy), GetFFlagAddPeoplePageCardLayout (copy)
	local v37 = React.useMemo(function() -- line: 123
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("PeopleListStore")
	end, {})
	local v38 = useSignalState(v37.people)
	local v39 = React.useRef(nil)
	local v40 = React.useRef({})
	local v41 = React.useRef({})
	local v42, v43 = buildPersonRows(v38, v40.current, v41.current, if not FFlagEnablePeopleListLazyRender then nil else t7.scrollingFrameStore)

	v40.current = v42
	v41.current = v43

	local current = v40.current

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = not GetFFlagAddPeoplePageCardLayout() and 2 or t7.LayoutOrder
	}, {
		PeopleList = React.createElement(View, {
			tag = "size-full-0 col gap-small auto-y",
			ref = v39
		}, { current })
	})
end

if v11.FFlagPeoplePageRemoveUseMemoElements then
	return React.memo(PeopleList)
end

return PeopleList
