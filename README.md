**SpeechWave** is a sophisticated text-to-speech converter app. Designed with a focus on simplicity and ease of use, the app allows users to scan documents, import files, and convert text to speech with minimal effort.
The intuitive interface guides users through each step, making advanced features accessible to everyone.
This application seamlessly integrates several advanced frameworks (Vision, AVFoundation, VisionKit, PDFKit) to deliver an accessible and efficient solution.

**Key features**: text scanning via camera, PDF import, text recognition and conversion, speech playback, text copying, file saving, and managing saved files.

***Technologies and Approaches:***

1.Text Recognition with Vision Framework:

Utilized Apple's Vision framework for high-accuracy text recognition from scanned documents and images. By using its OCR capabilities, SpeechWave ensures accurate and efficient text extraction from images and documents.
Users can quickly scan physical documents or import digital files to extract text, making the app versatile for various scenarios such as digitizing printed materials or processing electronic documents.

2. Speech Conversion using AVFoundation:

Integrated AVSpeechSynthesizer from the AVFoundation framework to convert recognized text into speech. Customization of AVSpeechSynthesizerDelegate functions allowed precise control over audio playback, enhancing the user experience with real-time feedback and progress tracking.
The ability to convert text to speech allows users to listen to their documents, which is particularly beneficial for those with visual impairments or those who prefer auditory learning


3. Document Scanning with VisionKit:

Integrated VNDocumentCameraViewController from VisionKit for document scanning, implementing custom logic in VNDocumentCameraViewControllerDelegate to handle document capture and processing efficiently. This allows users to scan physical documents with ease.
This feature allows users to digitize physical documents on-the-go, making it convenient for students, professionals, and anyone needing to convert printed text into digital format. 

5. PDF Import and Processing with PDFKit:

Utilized the fileImporter component for importing PDF files and processed them using PDFKit framework functionalities. This enables users to import and convert text from existing digital documents accurately, ensuring that the app will handle all the processing of the file.

