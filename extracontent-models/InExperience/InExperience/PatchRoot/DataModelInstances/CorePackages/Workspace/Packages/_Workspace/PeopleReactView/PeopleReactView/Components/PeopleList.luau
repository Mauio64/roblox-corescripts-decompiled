local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local PeopleService = require(parent.PeopleService)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View
local useSignalState = SignalsReact.useSignalState

local PersonRow = require(PeopleReactView.Components.List.PersonRow)
local LazyPersonRow = require(PeopleReactView.Components.List.LazyPersonRow)

require(PeopleReactView.Stores.GetScrollingFrameStore)

local service = PeopleService.getService("Flags")
local getFFlagAddPeoplePageCardLayout = service.GetFFlagAddPeoplePageCardLayout
local fFlagEnablePeopleListLazyRender = service.FFlagEnablePeopleListLazyRender

local function MemoizedPersonRow(data)
	return React.useMemo(function()
		if fFlagEnablePeopleListLazyRender then
			return (React.createElement(LazyPersonRow, {
				key = tostring(data.person.UserId),
				person = data.person,
				layoutOrder = data.index,
				scrollingFrameStore = data.scrollingFrameStore
			}))
		end

		return (React.createElement(PersonRow, {
			key = tostring(data.person.UserId),
			person = data.person,
			layoutOrder = data.index
		}))
	end, { data.person.UserId, data.index, data.scrollingFrameStore })
end

local function buildPersonRows(list, current, current2, p)
	local children = {}
	local result = {}
	local v = 0

	if not next(current2) then
		for k, item in list do
			current2[item.UserId] = (k - 1) * math.floor(100000 / #list)
		end
	end

	for k, item in list do
		if current[item.UserId] then
			children[item.UserId] = current[item.UserId]
			result[item.UserId] = current2[item.UserId]
			v = current2[item.UserId]
		else
			if k == 1 then
				v = 0
			else
				local v2 = k + 1
				local v3 = 100000

				while v2 <= #list do
					local userId = list[v2].UserId

					if current2[userId] then
						v3 = current2[userId]
						break
					end

					v2 += 1
				end

				v = math.floor((v + v3) / 2)
			end

			local userId = item.UserId
			local createElement = React.createElement
			local scrollingFrameStore

			if fFlagEnablePeopleListLazyRender then
				scrollingFrameStore = p
			end

			children[userId] = createElement(MemoizedPersonRow, {
				person = item,
				index = v,
				scrollingFrameStore = scrollingFrameStore
			})

			result[item.UserId] = v
		end
	end

	return children, result
end

local function PeopleList(p)
	local v = useSignalState(React.useMemo(function()
		return PeopleService.getService("PeopleListStore")
	end, {}).people)
	local ref = React.useRef(nil)

	local ref2 = React.useRef({})
	local ref3 = React.useRef({})

	local current = ref2.current
	local current2 = ref3.current
	local v2

	if fFlagEnablePeopleListLazyRender then
		v2 = p.scrollingFrameStore
	end

	local personRows, current4 = buildPersonRows(v, current, current2, v2)
	ref2.current = personRows
	ref3.current = current4

	local current3 = ref2.current

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = not getFFlagAddPeoplePageCardLayout() and 2 or p.LayoutOrder
	}, {
		PeopleList = React.createElement(View, {
			tag = "size-full-0 col gap-small auto-y",
			ref = ref
		}, { current3 })
	})
end

if service.FFlagPeoplePageRemoveUseMemoElements then
	return React.memo(PeopleList)
end

return PeopleList
