require "open-uri" 
require "nokogiri"

namespace :scrape do 
  desc "Race results for a given date"
  task :race_results => :environment do

    url = "http://racing.hkjc.com/racing/Info/Meeting/Results/English"
    parsed_data = Nokogiri::HTML(open(url))
    
    i = 0
    
    while (i <= 1) do
      j = 1
      next_page = parsed_data.css('#raceDateSelect > option')[i].attr('value')
      while (j <= 16) do
        url = "http://racing.hkjc.com/racing/Info/Meeting/Results/English/#{next_page}/#{j}"
        puts url
        data = Nokogiri::HTML(open(url))
        OneLine(data, j)
        j += 1
      end
      i += 1
    end

  end
end

def OneLine(parsed_data, j)
  distance = parsed_data.css('table > tbody > tr > td > span.number14')
  # distance = "1234m"
  date = parsed_data.css('#raceDateSelect option[@selected="selected"]')
  racenumber = j
  rank = parsed_data.css('div.clearDivFloat.rowDiv15 > table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(1)')
  number = parsed_data.css('div.clearDivFloat.rowDiv15 > table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(2)')
  horse = parsed_data.css('table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(3).tdAlignL.font13.fontStyle > a:nth-child(1)')
  jockey = parsed_data.css('table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(4).tdAlignL.font13.fontStyle > a:nth-child(1)')
  trainer = parsed_data.css('table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(5).tdAlignL.font13.fontStyle > a:nth-child(1)')
  actualweight = parsed_data.css('div.clearDivFloat.rowDiv15 > table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(6)')
  horseweight = parsed_data.css('div.clearDivFloat.rowDiv15 > table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(7)')
  draw = parsed_data.css('div.clearDivFloat.rowDiv15 > table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(8)')
  lbw = parsed_data.css('div.clearDivFloat.rowDiv15 > table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(9)')
  runningposition1 = parsed_data.css('td:nth-child(10) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1)')
  runningposition2 = parsed_data.css('td:nth-child(10) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2)')
  runningposition3 = parsed_data.css('td:nth-child(10) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(3)')
  runningposition4 = parsed_data.css('td:nth-child(10) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(4)')
  runningposition5 = parsed_data.css('td:nth-child(10) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5)')
  finishtime = parsed_data.css('div.clearDivFloat.rowDiv15 > table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(11)')
  odd = parsed_data.css('div.clearDivFloat.rowDiv15 > table.tableBorder.trBgBlue.tdAlignC.number12.draggable > tbody > tr > td:nth-child(12)')

  rank.each_with_index do |item, index|
    new_result = Race.new   
    new_result.distance = distance.text                         unless distance.nil?
    new_result.date = date[0].text                              unless date[0].nil?  
    new_result.racenumber = racenumber                          unless racenumber.nil?
    new_result.rank = rank[index].text                          unless rank[index].nil?
    new_result.number = number[index].text                      unless number[index].nil?
    new_result.horse = horse[index].text                        unless horse[index].nil?
    new_result.jockey = jockey[index].text                      unless jockey[index].nil?
    new_result.trainer = trainer[index].text                    unless trainer[index].nil?
    new_result.actualweight = actualweight[index].text          unless actualweight[index].nil?
    new_result.horseweight = horseweight[index].text            unless horseweight[index].nil?
    new_result.draw = draw[index].text                          unless draw[index].nil?
    new_result.lbw = lbw[index].text                            unless lbw[index].nil?
    new_result.runningposition1 = runningposition1[index].text  unless runningposition1[index].nil?
    new_result.runningposition2 = runningposition2[index].text  unless runningposition2[index].nil?
    new_result.runningposition3 = runningposition3[index].text  unless runningposition3[index].nil?
    new_result.runningposition4 = runningposition4[index].text  unless runningposition4[index].nil?
    new_result.runningposition5 = runningposition5[index].text  unless runningposition5[index].nil?
    new_result.finishtime = finishtime[index].text              unless finishtime[index].nil?
    new_result.odd = odd[index].text                            unless odd[index].nil?

    if new_result.save
     puts "#{new_result.date} saved in db"
    else
     puts "#{new_result.date} not saved in db"
    end
  end
end