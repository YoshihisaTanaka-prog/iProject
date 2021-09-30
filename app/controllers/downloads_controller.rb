class DownloadsController < ApplicationController

    def index
        strongest_limit
    
        # 以下、追記
        respond_to do |format|
            format.html
            format.xlsx do
                # ファイル名をここで指定する（動的にファイル名を変更できる）
                response.headers['Content-Disposition'] = "attachment; filename=AllData-#{Date.today}.xlsx"
            end
        end
    end

end
