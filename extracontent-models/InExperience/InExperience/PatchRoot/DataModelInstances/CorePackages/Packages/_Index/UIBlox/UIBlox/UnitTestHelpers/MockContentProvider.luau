local ParentParent = script.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 38
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, {
		__index = t1
	})
	t2.callback = p1
	t2.connected = true
	t2.isMock = 231

	return t2
end
function t1.Fire(p2, p3) -- line: 50
	if p2.connected then
		p2.callback(p3)
	end
end
function t1.Disconnect(p4) -- line: 56
	p4.connected = false
end

local t3 = {}

t3.__index = t3

function t3.new() -- line: 65
	-- upvalues: t3 (copy)
	local t4 = {}

	setmetatable(t4, {
		__index = t3
	})
	t4.connections = {}

	return t4
end
function t3.Connect(p5, p6) -- line: 75
	-- upvalues: t1 (copy)
	local v14 = t1.new(p6)

	table.insert(p5.connections, v14)

	return v14
end
function t3.Fire(p7, p8) -- line: 81
	for _, v18 in p7.connections do
		v18:Fire(p8)
	end
end

local t5 = {}

t5.__index = t5

function t5.new(p9, p10, p11) -- line: 92
	-- upvalues: t5 (copy)
	local t6 = {}

	setmetatable(t6, {
		__index = t5
	})
	t6.mockContentProviderProceedWithLoad = false
	t6.contentResolved = false
	t6.assetFetchStatuses = {}
	t6.signals = {}
	t6.preloadAsyncCalled = false
	t6.isMock = true
	t6.ultimatelySuccessfulContentIds = p9 or {}
	t6.ultimatelyTimedOutContentIds = p10 or {}
	t6.ultimatelyFailedContentIds = p11 or {}

	return t6
end
function t5.mockReload(p12, p13, p14) -- line: 114
	p12.mockContentProviderProceedWithLoad = false
	p12:_staggeredProgress(nil, p13, p14 or Enum.AssetFetchStatus.Success)
end
function t5.proceedWithLoad(p15) -- line: 120
	-- upvalues: Roact (copy)
	p15.mockContentProviderProceedWithLoad = true
	Roact.act(function() -- line: 122
		task.wait(0.1)
	end)
end
function t5._setAssetFetchStatus(p16, p17, p18) -- line: 127
	p16.assetFetchStatuses[p17] = p18

	if p16.signals[p17] then
		p16.signals[p17]:Fire(p18)
	end
end
function t5._staggeredProgress(p19, p20, p21, p22) -- line: 134
	p19.contentResolved = false
	task.spawn(function() -- line: 137
		-- upvalues: p19 (copy), p21 (copy), p20 (copy), p22 (copy)
		while true do
			if p19.mockContentProviderProceedWithLoad then
				if p19.contentResolved then
					p19:_setAssetFetchStatus(p21, p22)

					if p20 then
						p20(p21, p22)
					end

					p19.mockContentProviderProceedWithLoad = false

					return
				end

				p19:_setAssetFetchStatus(p21, Enum.AssetFetchStatus.Loading)

				if p20 then
					p20(p21, Enum.AssetFetchStatus.Loading)
				end

				p19.contentResolved = true
				p19.mockContentProviderProceedWithLoad = false
			end

			task.wait()
		end
	end)
end
function t5._makeMockSignal(_) -- line: 161
	-- upvalues: t3 (copy)
	return (t3.new())
end
function t5.GetAssetFetchStatusChangedSignal(p24, p25) -- line: 166
	if p24.signals[p25] == nil then
		p24.signals[p25] = p24:_makeMockSignal()
	end

	return p24.signals[p25]
end
function t5.GetAssetFetchStatus(p26, p27) -- line: 173
	if p26.assetFetchStatuses[p27] ~= nil then
		return p26.assetFetchStatuses[p27]
	end

	return Enum.AssetFetchStatus.None
end
function t5.PreloadAsync(p28, p29, p30) -- line: 181
	p28.preloadAsyncCalled = true

	for _, v in ipairs(p29) do
		if p28.ultimatelySuccessfulContentIds[v] then
			p28:_staggeredProgress(p30, v, Enum.AssetFetchStatus.Success)
		elseif p28.ultimatelyTimedOutContentIds[v] then
			p28:_staggeredProgress(p30, v, Enum.AssetFetchStatus.TimedOut)
		elseif p28.ultimatelyFailedContentIds[v] then
			p28:_staggeredProgress(p30, v, Enum.AssetFetchStatus.Failure)
		else
			task.delay(0, function() -- line: 191
				-- upvalues: p28 (copy), v (copy), p30 (copy)
				p28:_setAssetFetchStatus(v, Enum.AssetFetchStatus.Success)

				if p30 then
					p30(v, Enum.AssetFetchStatus.Success)
				end
			end)
		end
	end
end

return t5
