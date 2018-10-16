RSpec.describe ActivejobArguments do
  it 'has a version number' do
    expect(ActivejobArguments::VERSION).not_to be nil
  end

  it 'handles classes' do
    serialized = ActiveJob::Arguments.serialize_argument(ActiveJob::Arguments)
    expect(ActiveJob::Arguments.deserialize_argument(serialized)).to eq(ActiveJob::Arguments)
  end

  it 'handles symbols' do
    serialized = ActiveJob::Arguments.serialize_argument(:args)
    expect(ActiveJob::Arguments.deserialize_argument(serialized)).to eq(:args)
  end

  it 'handles array of symbols' do
    serialized = ActiveJob::Arguments.serialize_argument([:args1, :args2, :args3])
    expect(ActiveJob::Arguments.deserialize_argument(serialized)).to eq([:args1, :args2, :args3])
  end

  it 'handles hashes' do
    hash = {
      'a' => 1,
      :b => 2
    }
    serialized = ActiveJob::Arguments.serialize_argument(hash)
    expect(ActiveJob::Arguments.deserialize_argument(serialized)).to eq(hash)
  end

  it 'handles Time' do
    time = Time.new(2018, 9, 17, 12, 36, 1)
    serialized = ActiveJob::Arguments.serialize_argument(time)
    expect(ActiveJob::Arguments.deserialize_argument(serialized)).to eq(time)
  end

  it 'handles DateTime' do
    time = Time.new(2018, 9, 17, 12, 36, 1)
    serialized = ActiveJob::Arguments.serialize_argument(time)
    expect(ActiveJob::Arguments.deserialize_argument(serialized)).to eq(time)
  end
end
