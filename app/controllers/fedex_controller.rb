class FedexController < ApplicationController


  def index
    require 'fedex'
    fedex = Fedex::Shipment.new(:key => 'O21wEWKhdDn2SYyb',
                            :password => 'db0SYxXWWh0bgRSN7Ikg9Vunz',
                            :account_number => '510087780',
                            :meter => '119009727',
                            :mode => 'test')
    valoresJson = parsearJson()

    @arrayResultados = Array.new

    valoresJson.each do |vJ|
        resultados = Array.new
        pesoVolumetrico = vJ["parcel"]["length"].to_f * vJ["parcel"]["width"].to_f * vJ["parcel"]["height"].to_f
        pesoVolumetrico = pesoVolumetrico / 5000
        peso = vJ["parcel"]["weight"].to_f


        if (peso > pesoVolumetrico)
          pesoTotal = peso.ceil
        else
          pesoTotal = pesoVolumetrico.ceil
        end

      
        results = fedex.track(:tracking_number => vJ["tracking_number"] )
        tracking_info = results.first
        packDimensions = tracking_info.details[:package_dimensions]
        packWeight = tracking_info.details[:package_weight]

        #Peso_Real_Fedex pasar a Kilogramos
        packWeightKilos = (packWeight[:value].to_f / 2.205)

        #Peso_Volumetrico_Fedex pasar a cm
        packDimensions = tracking_info.details[:package_dimensions]
        packDimensionsLengthCm = packDimensions[:length].to_f * 2.54
        packDimensionsWidthCm = packDimensions[:width].to_f * 2.54
        packDimensionsHeightCm = packDimensions[:height].to_f * 2.54

        volumenFedex = packDimensionsWidthCm.to_f * packDimensionsLengthCm.to_f * packDimensionsHeightCm.to_f
        peso_Volumetrico_Fedex = volumenFedex/5000

        if (packWeightKilos > peso_Volumetrico_Fedex)
          pesoTotalFedex = packWeightKilos.ceil
        else
          pesoTotalFedex = peso_Volumetrico_Fedex.ceil
        end



        resultados.push(pesoTotal.ceil)
        resultados.push(pesoTotalFedex.ceil)
        sobrePeso = pesoTotal.ceil - pesoTotalFedex.ceil
        if(sobrePeso > 0)
          sobrePeso = pesoTotalFedex
        else
          sobrePeso = 0
        end

resultados << sobrePeso
        @arrayResultados.push(resultados)

    end
  end


  def parsearJson()
    return JSON.parse(File.read('app/assets/javascripts/labels.json'))
  end

end
