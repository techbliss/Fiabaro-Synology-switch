-- Device Controller is a little more advanced than other types. 
-- It can create child devices, so it can be used for handling multiple physical devices.
-- E.g. when connecting to a hub, some cloud service or just when you want to represent a single physical device as multiple endpoints.
-- 
-- Basic knowledge of object-oriented programming (oop) is required. 
-- Learn more about oop: https://en.wikipedia.org/wiki/Object-oriented_programming 
-- Learn more about managing child devices: https://manuals.fibaro.com/home-center-3-quick-apps/

function QuickApp:onInit()
    self:debug("QuickApp:onInit")
    --self.udp = net.UDPSocket({ broadcast = true}) 

    -- Setup classes for child devices.
    -- Here you can assign how child instances will be created.
    -- If type is not defined, QuickAppChild will be used.
    self:initChildDevices({
        ["com.fibaro.binarySwitch"] = MyBinarySwitch,
    })

    -- Print all child devices.
    self:debug("Child devices:")
    for id,device in pairs(self.childDevices) do
        self:debug("[", id, "]", device.name, ", type of: ", device.type)
    end
end
function QuickApp:synOff()
    local http = net.HTTPClient()

     print(tostring("hello"))
     local getip = self:getVariable("Ip Address")
     print(tostring(getip))
     local http = net.HTTPClient({timeout = 5000})  --  5 seconds
  local data = nil
 
  local url = "http://"..self:getVariable("Ip Address")..":"..self:getVariable("Port").."/webapi/auth.cgi?api=SYNO.API.Auth&version=3&method=login&account="..self:getVariable("Username").."&passwd="..self:getVariable("Password").."&format=cookie'"
  print(url)

    local inputheaders = {
    ['accept'] = 'application/json', 
    ['Content-Type'] = 'application/x-www-form-urlencoded'

    }

  http:request(url, {
    options = {
      method = "GET",
     headers = inputheaders,
     data = ""
    },  
     success = function(response)
       self:debug(response.status)
      -- stats = function(response)
   --     print(success..yubiii)
        self:debug(response.data)
        bob = response.data
        b = string.sub(bob, 17, 102)
        c = string.sub(bob, 112, 197)
        print(b)
        print(c)
        if response.status == 200  then
            self:updateView("label1", "text", "Connected")
        end
        
            local url2 = "http://"..self:getVariable("Ip Address")..":"..self:getVariable("Port").."/webapi//entry.cgi?api=SYNO.Core.System&version=1&method=shutdown&_did="..tostring
            (b).."&_sid="..tostring(c)
            print(url2)
           -- print(tostring(url2.."/api=SYNO.Core.System&method=shutdown&version=1"))
            http:request(url2, {
                options = {
                    method = "GET",
                    headers = {
                    },

                }
               
            })
    end,  --  success
    
  })
end




function QuickApp:synOn()
   --
    --00:11:32:32:32:0f
    mac1 = string.char(0x00,0x11,0x32,0x66,0x0a,0x0f)--puthere you mac adress
    for i=1,4 do
        mac1 = mac1..mac1  
    end

    mac2 = string.char(0xff,0xff,0xff,0xff,0xff,0xff)..string.char(0xff,0xff,0xff,0xff,0xff,0xff)..string.char(0xff,0xff,0xff,0xff,0xff,0xff)..string.char(0xff,0xff,0xff,0xff,0xff,0xff)..string.char(0xff,0xff,0xff,0xff,0xff,0xff)..string.char(0xff,0xff,0xff,0xff,0xff,0xff)..mac1---Magic packet needs broadcast MAC in front to wake up
    --ref https://www.esp8266.com/viewtopic.php?f=19&t=2981

    self.udp = net.UDPSocket({ 
        broadcast = true,
        timeout = 3000
    })

    self.udp:sendTo(mac2, self:getVariable("Broadcast adres"), 9, {
        success = function()
        self:trace("OK send magic package")
         --   self:receiveData()
        --    self.udp:close()
            if success == success then
                self:updateView("label2", "text", "Wake on Lan package send")
            end
       -- self:receiveData()
        end,
        error = function(error)
        print('Error:', error)
        if error == error then
            self:updateView("label2", "text", "Error")
        end
    end
    })
    --   self.udp:close()

end

function QuickApp:createChild()
    local child = self:createChildDevice({
        name = "child",
        type = "com.fibaro.binarySwitch",
        }, MyBinarySwitch)

    self:trace("Child device created: ", child.id)
end

-- Sample class for handling your binary switch logic. You can create as many classes as you need.
-- Each device type you create should have its class which inherits from the QuickAppChild type.
class 'MyBinarySwitch' (QuickAppChild)

-- __init is a constructor for this class. All new classes must have it.
function MyBinarySwitch:__init(device)
    -- You should not insert code before QuickAppChild.__init. 
    QuickAppChild.__init(self, device) 

    self:debug("MyBinarySwitch init")   
end

function MyBinarySwitch:turnOn()
    self:debug("child", self.id, "turned on")
    self:updateProperty("value", true)
end

function MyBinarySwitch:turnOff()
    self:debug("child", self.id, "turned off")
    self:updateProperty("value", false)
end
