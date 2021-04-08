//
//  ViewController.swift
//  Instagrid
//
//  Created by Adam Mokhtar on 05/11/2019.
//  Copyright © 2019 Adam Mokhtar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    //----------------------------------------------------------------------------
    // MARK: - Properties
    //----------------------------------------------------------------------------

    /******************** Selected Layout ********************/

    @IBOutlet weak var selectedLayout1: UIImageView!

    @IBOutlet weak var selectedLayout2: UIImageView!

    @IBOutlet weak var selectedLayout3: UIImageView!

    /******************** View Layout ********************/

    @IBOutlet weak var ViewPicture1: UIView!

    @IBOutlet weak var ViewPicture2: UIView!

    @IBOutlet weak var ViewPicture3: UIView!

    @IBOutlet weak var ViewPicture4: UIView!


    /******************** Pictures ********************/

    @IBOutlet weak var pictures1: UIImageView!

    @IBOutlet weak var pictures2: UIImageView!

    @IBOutlet weak var pictures3: UIImageView!

    @IBOutlet weak var pictures4: UIImageView!

    /******************** Sharing  ********************/

    @IBOutlet weak var sharingView: UIView!

    @IBOutlet weak var labelSwipe: UILabel!

    @IBOutlet weak var arrowImg: UIImageView!

    @IBOutlet weak var swipeStack: UIStackView!

    /******************** Image Picker ********************/

    private let imagePicker = UIImagePickerController()

    enum Index {
        case one, two, three, four
    }

    var selectedImageIndex = Index.one

    //----------------------------------------------------------------------------
    // MARK: - View Life Cycle
    //----------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSwipe()
    }

    //----------------------------------------------------------------------------
    // MARK: - Function
    //----------------------------------------------------------------------------

    /******************** Layout ********************/

    @IBAction func buttonLayout1(_ sender: UIButton) {
        select1()
    }

    @IBAction func buttonLayout2(_ sender: UIButton) {
        select2()
    }

    @IBAction func buttonLayout3(_ sender: UIButton) {
        select3()
    }

    /******************** Button + ********************/

    @IBAction func plusButton1(_ sender: Any) {
        loadPictureOne()
    }

    @IBAction func plusButton2(_ sender: Any) {
        loadPictureTwo()
    }

    @IBAction func plusButton3(_ sender: Any) {
        loadPictureThree()
    }

    @IBAction func plusButton4(_ sender: Any) {
        loadPictureFour()
    }

    //----------------------------------------------------------------------------
    // MARK: - Load Pictures
    //----------------------------------------------------------------------------

    @objc func loadPictureOne() {
        selectedImageIndex = Index.one
        present(imagePicker, animated: true)
    }

    @objc func loadPictureTwo() {
        selectedImageIndex = Index.two
        present(imagePicker, animated: true)
    }

    @objc func loadPictureThree() {
        selectedImageIndex = Index.three
        present(imagePicker, animated: true)
    }

    @objc func loadPictureFour() {
        selectedImageIndex = Index.four
        present(imagePicker, animated: true)
    }

    //----------------------------------------------------------------------------
    // MARK: - Sharing / Animation
    //----------------------------------------------------------------------------

    /******************** Swipe ********************/

    /// Share SharingView and anime the comeback of the view when the action is
    /// ended.
    @objc private func swipeToShare(gesture: UISwipeGestureRecognizer) {

        if UIDevice.current.orientation.isLandscape {
            swipeLeftAnimation()
        } else if UIDevice.current.orientation.isPortrait {
            swipeUpAnimation()
        }

        let image = UIImage.imageWithView(sharingView)

        let shareActivityVC =
            UIActivityViewController(activityItems: [image],
                                     applicationActivities: nil)

        shareActivityVC.completionWithItemsHandler = { _, _, _, _ in
            let comebackAnimation = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(
                withDuration: 0.3,
                delay: 0.0,
                options: [],
                animations: { self.sharingView.transform = comebackAnimation },
                completion: nil)
        }
        shareActivityVC.popoverPresentationController?.sourceView = self.view
        self.present(shareActivityVC, animated: true)
    }



    //----------------------------------------------------------------------------
    // MARK: - Animation
    //----------------------------------------------------------------------------


    /// Swipe left animation.
    private func swipeLeftAnimation () {
        let left = CGAffineTransform(translationX: -1000, y: 0)
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       options: [],
                       animations: { self.sharingView.transform = left },
                       completion: nil)
    }

    /// Swipe up animation.
    private func swipeUpAnimation () {
        let top = CGAffineTransform(translationX: 0, y: -1000)

        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       options: [],
                       animations: { self.sharingView.transform = top },
                       completion: nil)
    }

    //----------------------------------------------------------------------------
    // MARK: - Setup
    //----------------------------------------------------------------------------

    private func setup() {
        setupImagePicker()
        setupSelectedImage()
    }

    func setupSelectedImage() {
        selectedLayout3.isHidden = false
    }

    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }

    /// Change the text and the arrow when the device rotate.
    private func setupSwipe() {
        removeGestures()

        if UIDevice.current.orientation.isLandscape {
            addSwipeLeftGesture()
        } else if UIDevice.current.orientation.isPortrait {
            addSwipeUpGesture()
        }
    }


    private func removeGestures() {
        swipeStack.gestureRecognizers?.forEach() { gestures in
            swipeStack.removeGestureRecognizer(gestures)
        }
    }


    private func addSwipeLeftGesture() {
        let swipe =
            UISwipeGestureRecognizer(target: self,
                                     action: #selector(swipeToShare(gesture:)))
        swipe.direction = .left
        swipeStack.addGestureRecognizer(swipe)
        labelSwipe.text = "Swipe left to share"
        arrowImg.image = #imageLiteral(resourceName: "Arrow Left.png")
    }

    private func addSwipeUpGesture() {
        let swipe =
            UISwipeGestureRecognizer(target: self,
                                     action: #selector(swipeToShare(gesture:)))
        swipe.direction = .up
        swipeStack.addGestureRecognizer(swipe)
        labelSwipe.text = "Swipe up to share"
        arrowImg.image = #imageLiteral(resourceName: "Arrow Up")

    }

    //----------------------------------------------------------------------------
    // MARK: - Pictures
    //----------------------------------------------------------------------------

    /// Use pictures in the library of the phone according to the view chooses.
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {

        if let image =
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if selectedImageIndex == Index.one {
                pictures1.image = image
            } else if selectedImageIndex == Index.two  {
                pictures2.image = image
            } else if selectedImageIndex == Index.three {
                pictures3.image = image
            } else if selectedImageIndex == Index.four {
                pictures4.image = image
            }
            dismiss(animated:true, completion: nil)
        }
    }

    //----------------------------------------------------------------------------
    // MARK: - Layout
    //----------------------------------------------------------------------------

    /// show selected View for organise the layout.
    private func deSelectedAllLayouts() {
        let selectedLayouts: [UIImageView] =
            [selectedLayout1, selectedLayout2, selectedLayout3]
        for selectedLayout in selectedLayouts {
            selectedLayout.isHidden = false
        }
    }

    /// show ViewPicture for organise the layout.
    private func showAllPictures() {
        let selectedPictures: [UIView] =
            [ViewPicture1, ViewPicture2, ViewPicture3, ViewPicture4]
        for selectedPicture in selectedPictures {
            selectedPicture.isHidden = false
        }
    }

    /// Organizes for layout 1.
    @objc private func select1 () {
        deSelectedAllLayouts()
        showAllPictures()
        selectedLayout2.isHidden = true
        selectedLayout3.isHidden = true
        ViewPicture2.isHidden = true
    }

    /// Organizes for layout 2.
    @objc private func select2 () {
        deSelectedAllLayouts()
        showAllPictures()
        selectedLayout1.isHidden = true
        selectedLayout3.isHidden = true
        ViewPicture4.isHidden = true
    }

    /// Organizes for layout 3.
    @objc private func select3 () {
        deSelectedAllLayouts()
        showAllPictures()
        selectedLayout2.isHidden = true
        selectedLayout1.isHidden = true
    }
}
