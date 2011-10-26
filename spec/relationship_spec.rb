require 'spec_helper'
require 'mocks/mocks'

describe "node specs" do

  describe "dealing with Relationship" do

    it "should load a relationship by id"

    it "should instance the relationship wrapper"

  end

  describe "relationships creation" do

    it "should create a 'one' relationship between user and userType" do

      user     = NeologyUser.create
      userType = NeologyUserType.create

      user.type = userType
      user.type.id.should == userType.id

    end

    it "should create a 'n' relationship between userType and user" do

      user_a   = NeologyUser.create
      user_b   = NeologyUser.create
      userType = NeologyUserType.create

      userType.user<<user_a
      userType.user<<user_b

      userType.user.size.should == 2
      userType.user.collect do |rel|
        rel.end_node
      end.should include(user_a, user_b)

    end

    it "shouldn't be able to assign a comment to userType.user relationship" do

      comment  = NeologyComment.create
      userType = NeologyUserType.create

      lambda { userType.user << comment }.should raise_exception

    end

    it "should return relations of 'neology_r_author' kind" do

      comment = NeologyComment.create
      user    = NeologyUser.create

      comment.author= user
      rels          = comment.rels(:author)

      rels.size.should == 1
      rels[0].kind_of?(NeologyRAuthor).should be_true

    end

    it "should return only all the relations" do

      comment = NeologyComment.create
      user    = NeologyUser.create
      voter_1 = NeologyUser.create
      voter_2 = NeologyUser.create
      voter_3 = NeologyUser.create
      voter_4 = NeologyUser.create

      comment.author= user
      comment.voters<<[voter_1, voter_2, voter_3, voter_4]

      voters = comment.rels
      voters.size.should == 5

    end

    it "should return only voters relations" do

      comment = NeologyComment.create
      user    = NeologyUser.create
      voter_1 = NeologyUser.create
      voter_2 = NeologyUser.create
      voter_3 = NeologyUser.create
      voter_4 = NeologyUser.create

      comment.author= user
      comment.voters<<[voter_1, voter_2, voter_3, voter_4]

      voters = comment.rels(:voters)
      voters.size.should == 4

      voters.collect { |rel|
        rel.end_node
      }.should =~ [voter_1, voter_2, voter_3, voter_4]

    end

    it "user should have only one incoming relationship (user.rel :incoming, :comment)"

    it "should be only one relationship between comment and voter 3"

    it "should return all outgoing relationships"

    it "should return all incoming relationships"

  end

end