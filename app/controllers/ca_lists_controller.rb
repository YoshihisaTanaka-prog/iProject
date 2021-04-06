class CaListsController < ApplicationController
    #before_actionで各メソッドを呼び出す前にメソッドを呼び出す
    #onlyでどのメソッドで呼び出すか制限をかける
    before_action :set_ca_list, only: [:show,:update,:edit,:delete]

    #index->データの一覧の表示
    def index
        #mythreadのデータの全件取得
        @controllers = CaList.all.order(:controller_name).pluck(:controller_name).uniq
        if !params[:cont].blank?
            @ca_lists = CaList.where(controller_name: params[:cont])
        else
            @ca_lists = CaList.all
        end
    end

    #show->個別データの表示
    def show
        #before_actionでデータの取得は完了している
    end

    #new->新規作成ページの表示
    def new
        #モデルオブジェクトの生成
        @ca_list = CaList.new
    end

    #create->新規データの登録
    def create
        #formのデータを受け取る
        @ca_list =CaList.create(ca_list_params)
        level = params[:level].to_i
        if level > 1
            @ca_list.minimum_level = level
        end
        case params[:option]
        when "level"
            @ca_list.is_only_level = true
        when "subadmin"
            @ca_list.is_only_subadmin = true
        when "admin"
            @ca_list.is_only_admin = true            
        end
        #saveメソッドでデータをセーブ　*newメソッド + saveメソッド = createメソッド
        if @ca_list.save
            #saveが完了したら、一覧ページへリダイレクト
            redirect_to autho_limitation_path
        else
            #saveを失敗すると新規作成ページへ
            render 'new'
        end
    end

    #edit->編集ページの表示
    def edit
        #before_actionでデータの取得は完了している
    end

    #update->編集のアップデート
    def update
        #編集データの取得
        @ca_list.controller_name = params[:controller_name]
        @ca_list.action_name = params[:action_name]

        case params[:option]
        when "level"
            @ca_list.is_only_level = true
        when "subadmin"
            @ca_list.is_only_subadmin = true
        when "admin"
            @ca_list.is_only_admin = true
        end

        if @ca_list.save
            #updateが完了したら一覧ページへリダイレクト
            redirect_to autho_limitation_path
        else
            #updateを失敗すると編集ページへ
            render 'edit'
        end
    end

    #destroy->データの削除
    def destroy
        #データの削除
        @ca_list.destroy
        #一覧ページへリダイレクト
        redirect_to autho_limitation_path
    end

    private
    #strong parameters リクエストパラメターの検証（これがないとうまくいかないので注意）
    def ca_list_params
        params.require(:ca_list).permit(:controller_name, :action_name, :path_name)
    end

    #共通処理なので、before_actionで呼び出している
    def set_ca_list
        if params[:id].blank?
            redirect_to autho_limitation_path
        end
        #特定データの取得
        @ca_list = CaList.find(params[:id].to_i)
    end
end
