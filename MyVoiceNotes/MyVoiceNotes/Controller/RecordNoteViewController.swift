//
//  RecordNoteViewController.swift
//  MyVoiceNotes
//
//  Created by Ronaldo Gomes on 20/10/20.
//

import UIKit
import AVFoundation

class RecordNoteViewController: UIViewController, AVAudioRecorderDelegate {

    var stackView: UIStackView!
    var recordNoteButton: UIButton!
    var recordingSession: AVAudioSession!
    var noteRecorder: AVAudioRecorder!
    var notePlayer: AVAudioPlayer!
    var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Grave sua nota"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
        recordSession()

    }
    
    //Criacao da stackView e suas constraints
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.gray
        
        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //Criacao da interface caso o usuario permita o acesso ao microfone
    func loadRecordingUI() {
        //Criacao do botao para iniciar a gravacao
        recordNoteButton = UIButton()
        recordNoteButton.translatesAutoresizingMaskIntoConstraints = false
        recordNoteButton.setTitle("Aperte para iniciar gravação", for: .normal)
        recordNoteButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        //Target para a funcao de
        recordNoteButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        stackView.addArrangedSubview(recordNoteButton)
        
        //Botao para comecar a ouvir
        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Aperte para escutar", for: .normal)
        playButton.isHidden = true
        playButton.alpha = 0
        playButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        stackView.addArrangedSubview(playButton)
    }

    //Criacao da interface caso o nao usuario permita o acesso ao microfone
    func loadFailUI() {
        let failLabel = UILabel()
        failLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        failLabel.text = "Gravacao interrompida: Autorize o microfone"
        failLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(failLabel)
    }
    
    //Funcao de quando o bottao de play é clicado
    @objc func playTapped() {
        
        //Pega a url da gravacao
        let audioURL = RecordNoteViewController.getRecordURL()

        do {
            //Tenta reproduzir o audio dessa url
            notePlayer = try AVAudioPlayer(contentsOf: audioURL)
            notePlayer.play()
        } catch {
            let ac = UIAlertController(title: "Playback falhou", message: "Houve um problema: Grave novamente a nota", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    //Faz acesso ao record session
    func recordSession() {
        //inicia a secao
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            //Pede a permissao para acessar o microfone
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.loadFailUI()
                    }
                }
            }
        } catch {
            self.loadFailUI()
        }
    }
    
    //Verifica se a gravacao foi finalizada pelo objeto ser nil ou nao e chama a funcao especifica
    @objc func recordTapped() {
        if noteRecorder == nil {
            startRecording()
            //Animacao de esconder o botao de play caso o usuario queira fazer uma nova gravacao
            if !playButton.isHidden {
                UIView.animate(withDuration: 0.35) { [unowned self] in
                    self.playButton.isHidden = true
                    self.playButton.alpha = 0
                }
            }
        } else {
            finishRecording(success: true)
        }
    }
    
    //Inicia a gravacao
    func startRecording() {
        //Faz a view ficar vermelha, para indicar que esta gravando
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)

        //Troca o titulo do botao para Tap to Stop
        recordNoteButton.setTitle("Tap to Stop", for: .normal)

        //Pega a url de onde salvar o arquivo
        let audioURL = RecordNoteViewController.getRecordURL()
        //print(audioURL.absoluteString)

        //Dicionario com algumas configuracoes da gravacao
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            //Criado um objeto AVAudioRecorder com suas configuracoes e delegates propio
            noteRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            noteRecorder.delegate = self
            //Inicia a gravacao
            noteRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    //Funcao do fim da gravacao, que recebe se foi o ou bem sucedido
    func finishRecording(success: Bool) {
        //Torna a view verde
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)

        //Para a gravacao e destroi o objeto atual
        noteRecorder.stop()
        noteRecorder = nil

        //Caso tenha sucesso na gravacao ou nao
        if success {
            recordNoteButton.setTitle("Aperte para gravar novamente", for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Proximo", style: .plain, target: self, action: #selector(nextTapped))
            
            //Animacao do botao de play
            if playButton.isHidden {
                UIView.animate(withDuration: 0.35) { [unowned self] in
                    self.playButton.isHidden = false
                    self.playButton.alpha = 1
                }
            }
        } else {
            recordNoteButton.setTitle("Tap to Record", for: .normal)

            let ac = UIAlertController(title: "Gravação falhou", message: "Houve um problema: Grave novamente a nota", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    //Funcoes de classe que pegam um diretoria vazio e gravam nele um arquiv
    //Elas sao de classe pois podem ser usadas em qualquer outra parte do app
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    class func getRecordURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("recordNote.m4a")
    }
    
    //Faz o push para a tela de generos musicais e comentarios
    @objc func nextTapped() {
        guard let notesDescription = UIStoryboard(name: "NoteDescription", bundle: nil).instantiateInitialViewController() as? NotesDescriptionViewController else {
            fatalError("Unexpected Error; \(String(describing: Error.self))")
        }
        navigationController?.pushViewController(notesDescription, animated: true)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
