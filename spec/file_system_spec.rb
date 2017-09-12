require_relative '../assets/lib/file_system'

describe 'FileSystem' do

  it 'creates files for specified paths' do
    variant1 = 'app-mips64-release.apk'
    variant2 = 'app-mips-release.apk'
    file1 = double('File')
    file2 = double('File')

    allow(Dir).to receive(:glob).and_return([variant1, variant2])
    allow(File).to receive(:new).with(variant1).and_return(file1)
    allow(File).to receive(:new).with(variant2).and_return(file2)

    variant_apks = FileSystem.new.get('*.apk')

    expect(variant_apks.size).to be(2)
    expect(variant_apks.first).to be(file1)
    expect(variant_apks.last).to be(file2)
  end
end
