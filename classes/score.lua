local _M = {}
_M.score = 0
 
function _M.init( options )
   local customOptions = options or {}
   local opt = {}
   opt.fontSize = customOptions.fontSize or 24
   opt.font = customOptions.font or native.systemFontBold
   opt.fontColor = customOptions.fontColor or 0
   opt.x = customOptions.x or display.contentCenterX
   opt.y = customOptions.y or opt.fontSize*0.5
   opt.maxDigits = customOptions.maxDigits or 6
   opt.leadingZeros = customOptions.leadingZeros or false
   --opt.varMaxCoins = customOptions.varMaxCoins or 0
   _M.filename = customOptions.filename or "scorefile.txt"
 
   local prefix = ""
   if ( opt.leadingZeros ) then 
      prefix = "0"
   end
   _M.format = "%" .. prefix .. opt.maxDigits .. "d"
 
   _M.scoreText = display.newText( "COINS: "..string.format(_M.format, 0).." / "..totalCoins, opt.x, opt.y, opt.font, opt.fontSize )
   _M.scoreText:setFillColor(opt.fontColor)
   return _M.scoreText
end

function _M.set( value )
   _M.score = value
   _M.scoreText.text = "COINS: "..string.format( _M.format, _M.score ).." / "..totalCoins
end
 
function _M.get()
   return _M.score
end
 
function _M.add( amount )
   _M.score = _M.score + amount
   _M.scoreText.text = "COINS: "..string.format( _M.format, _M.score ).." / "..totalCoins
end

function _M.save()
   local path = system.pathForFile( _M.filename, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local contents = tostring( _M.score )
      file:write( contents )
      io.close( file )
      return true
   else
      --print( "Error: could not read ", _M.filename, "." )
      return false
   end
end
 
function _M.load()
   local path = system.pathForFile( _M.filename, system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   if ( file ) then
      -- Read all contents of file into a string
      local contents = file:read( "*a" )
      local score = tonumber(contents);
      io.close( file )
      return score
   else
      --print( "Error: could not read scores from ", _M.filename, "." )
   end
   return nil
end
 
return _M