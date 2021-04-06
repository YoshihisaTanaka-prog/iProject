class CaListsController < ApplicationController
    #before_actionで各メソッドを呼び出す前にメソッドを呼び出す
    #onlyでどのメソッドで呼び出すか制限をかける
    before_action :set_ca_list, only: [:show,:update,:edit,:delete]

    #index->データの一覧の表示
    def index
        #mythreadのデータの全件取得
        @controllers = CAList.all.order(:controller_name).pluck(:controller_name).unique
        if params[:controller]
            @ca_lists = CAList.where(controller_name: params[:controller])
        else
            @ca_lists = CAList.all
        end
    end

    #show->個別データの表示
    def show
        #before_actionでデータの取得は完了している
    end

    #new->新規作成ページの表示
    def new
        #モデルオブジェクトの生成
        @ca_list = CAList.new
    end

    #create->新規データの登録
    def create
        #formのデータを受け取る
        @ca_list =CAList.create(ca_list_params)
        case params[:admin]
        when "subadmin"
            @ca_list.subadmin = true
            @ca_list.admin = true
        when "admin"
            @ca_list.admin = true
        else
            break            
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
        if @ca_list.update(ca_list_params)
            case params[:admin]
            when "subadmin"
                @ca_list.subadmin = true
                @ca_list.admin = true
            when "admin"
                @ca_list.admin = true
            else
                @ca_list.subadmin = false
                @ca_list.admin = false 
            end
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
        params.require(:ca_list).permit(:controller_name,:action_name)
    end

    #共通処理なので、before_actionで呼び出している
    def set_ca_list
        if params[:id].blank?
            redirect_to autho_limitation_path
        end
        #特定データの取得
        @ca_list = CAList.find(params[:id])
    end
end
