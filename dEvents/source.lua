--[[
  
  https://www.roblox.com/library/11825993636/dEvents
  https://github.com/DryOfficial/DryOfficial/
  
  ## dEvents is like works the same as RBXScriptSignal but it used for the public events.
  ## The Events be handled by the one of signal's function. When it's called, it will be fired.
  ##
  ## This Module is created by DryOfficial
  ##
  ## Arguments are self-explanatory by just its name.
  
| #### | 𝗙𝗨𝗡𝗖𝗧𝗜𝗢𝗡 library.addSignalTable(name)
       @ Creates Signal Table
       
| #### | 𝗙𝗨𝗡𝗖𝗧𝗜𝗢𝗡 library.addconnection(signalname, func)
       @ Creates connection inside signal.
       
| #### | 𝗙𝗨𝗡𝗖𝗧𝗜𝗢𝗡 library.fireAllConnectionsInSignal(name, ...)
       @ Fires all Connections in Signal Table
       
| #### | 𝗙𝗨𝗡𝗖𝗧𝗜𝗢𝗡 library.findSignalTable(name)
       @ Find Signal Table, returns nil when not found.
       
| #### | 𝗙𝗨𝗡𝗖𝗧𝗜𝗢𝗡 library.removeSignalTable(name, nameForReplacingToSignalTable)
       @ Remove Signal Table, optional for nameForReplacingSignalTable.
       @ nameForReplacingSignalTable is a optional input, put the other signal table name
       @ to replace ALL functions inside the Deleting Signal Table to the another.

--]]

local library = {}
local signalsTable = {}

local function clean(name)
	local cleanedTable = {}
	local errorsTable = {}
	for i,v in signalsTable[name] do
		if type(v) == 'function' then
			table.insert(cleanedTable, i, v)
		else
			table.insert(errorsTable, i, {
				index = i,
				value = v,
				valueType = type(v),
			})
		end
	end
	return cleanedTable,errorsTable
end

function library.addSignalTable(name)
	if not signalsTable[name] then
		signalsTable[name] = { }
	end
end

function library.addconnection(signalname, func, createWhenDontExist)
	if signalsTable[signalname] then
		table.insert(signalsTable[signalname], func) 
	else
		if createWhenDontExist then
			library.addSignalTable(signalname)
			library.addconnection(signalname, func)
		end
	end
end

function library.fireAllConnectionsInSignal(name, ...)
	if signalsTable[name] then
		local cleanedTable = clean(name)
		local functionArgsThatReturned = {}
		for index,_func in cleanedTable do
			table.insert(functionArgsThatReturned, {_func(...) :: any})
		end
		return functionArgsThatReturned
	end
end

function library.findSignalTable(name)
	return signalsTable[name]
end

function library.removeSignalTable(name, nameForReplacingToSignalTable)
	if signalsTable[name] then
		if nameForReplacingToSignalTable then
			local nFRTST = nameForReplacingToSignalTable
			if nFRTST ~= name then
				local signalTable = library.findSignalTable(name)
				for index,_func in signalTable do
					library.addconnection(nFRTST, _func)
				end
			end
		end
		signalsTable[name] = nil
	end
end

return library
