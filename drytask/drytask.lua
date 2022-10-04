--[=[----------------------------------------------------
		
		https://github.com/DryOfficial/DryOfficial/drytask/
		
		File Name : protask.lua [0.0.1]
		Creator   : DryOfficial#2363
		
		drytask (Dry Task) is a basically task but simplified (probably),
		concept and creation.
		
--]=]-----------------------------------------------------

--== Variables ==--

local drytask = {}
local runService = game:GetService('RunService')

--== Shortcuts ==--

type n             = number
type fv            = (any)->(any)
type a             = any
type anythingToPut = any -- Duplicated

--== Source ==--

function drytask.wait(n:n?): (n,n)
	n = n or 0
	local t = tick()
	local steptype = runService:IsClient() and 'RenderStepped' or 'Stepped'
	repeat runService[steptype]:Wait() until tick()-t>n
	return tick()-t,t
end

function drytask.spawn(func:fv,...:a): ...anythingToPut
	local t  = tick()
	local tl = tick()-t
	local  args = {func(...)}
	table.insert(args,tl)
	return table.unpack(args)
end

function drytask.spawnignore(func:fv,...:a): ...anythingToPut
	local t  = tick()
	local tl = tick()-t
	local added = {}
	local event = Instance.new('BindableEvent')
	local function done()
		event:Destroy()
	end
	local function eventfv(...)
		local args = {func(...)}
		for ind,val in args do
			table.insert(added,val)
		end
		drytask.spawn(done)
	end
	event.Event:Connect(eventfv)
	event:Fire(...)
	table.insert(added,tl)
	return table.unpack(added)
end

function drytask.delay(n:n,func:fv,...:a): ...anythingToPut
	local a,b = drytask.wait(n)
	local args = {drytask.spawn(func,...)}
	table.insert(args,a)
	return table.unpack(args)
end

return drytask
