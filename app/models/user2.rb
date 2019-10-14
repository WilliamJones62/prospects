class User2 < ApplicationRecord
  self.table_name = "fs_prospects_users"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable
 end
