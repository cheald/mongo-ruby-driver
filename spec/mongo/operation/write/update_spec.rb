require 'spec_helper'

describe Mongo::Operation::Write::Update do
  include_context 'operation'

  let(:updates) do
    [{ :q => { :foo => 1 },
       :u => { :$set => { :bar => 1 } },
       :multi => true,
       :upsert => false }]
  end

  let(:spec) do
    { :updates       => updates,
      :db_name       => db_name,
      :coll_name     => coll_name,
      :write_concern => write_concern,
      :ordered       => true
    }
  end
  let(:op) { described_class.new(spec) }



  describe '#initialize' do

    context 'spec' do

      it 'sets the spec' do
        expect(op.spec).to eq(spec)
      end
    end
  end

  describe '#==' do

    context 'spec' do

      context 'when two ops have the same specs' do
        let(:other) { described_class.new(spec) }

        it 'returns true' do
          expect(op).to eq(other)
        end
      end

      context 'when two ops have different specs' do
        let(:other_updates) { [{:q => { :foo => 1 },
                                :u => { :$set => { :bar => 1 } },
                                :multi => true,
                                :upsert => true }] }
        let(:other_spec) do
          { :updates       => other_updates,
            :db_name       => db_name,
            :coll_name     => coll_name,
            :write_concern => { 'w' => 1 },
            :ordered       => true
          }
        end
        let(:other) { described_class.new(other_spec) }

        it 'returns false' do
          expect(op).not_to eq(other)
        end
      end
    end
  end

  describe '#execute' do

    context 'server' do

      context 'when the type is secondary' do

        it 'throws an error' do
          expect{ op.execute(secondary_context) }.to raise_exception
        end
      end

      context 'server has wire version >= 2' do

        #it 'creates a write command update operation' do
        #  allow_any_instance_of(Mongo::Operation::Write::WriteCommand::Update).to receive(:new) do
        #    double('update_write_command').tap do |u|
        #      allow(u)).to receive(:execute) { [] }
        #    end
        #  end
#
        #  op.execute(primary_context)
        #end

        it 'calls execute on the write command update operation' do

        end
      end

      context 'server has wire version < 2' do

        context 'write concern' do

          context 'w > 0' do

            it 'calls get last error after each message' do
              expect(connection).to receive(:dispatch) do |messages|
                expect(messages.length).to eq(2)
              end
              op.execute(primary_context_2_4_version)
            end
          end

          context 'w == 0' do
            let(:write_concern) { Mongo::WriteConcern::Mode.get(:w => 0) }

            it 'does not call get last error after each message' do
              expect(connection).to receive(:dispatch) do |messages|
                expect(messages.length).to eq(1)
              end
              op.execute(primary_context_2_4_version)
            end
          end
        end

        context 'update messages' do
          let(:updates) do
            [{ :q => { :foo => 1 },
               :u => { :$set => { :bar => 1 } },
               :multi => true,
               :upsert => false },
             { :q => { :foo => 2 },
               :u => { :$set => { :bar => 2 } },
               :multi => true,
               :upsert => false }]
          end

          it 'sends each update message separately' do
            #expect(connection).to receive(:dispatch) do |messages|
            #  expect(updates).to include(messages.first)
            #end.exactly(updates.length).times
            #op.execute(primary_context)
          end
        end
      end
    end
  end
end